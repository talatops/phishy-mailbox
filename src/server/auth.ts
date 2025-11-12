import {type GetServerSidePropsContext} from 'next';
import {DefaultSession, getServerSession, type NextAuthOptions} from 'next-auth';
import Credentials from 'next-auth/providers/credentials';
import * as z from 'zod';
import * as bcrypt from 'bcrypt';

import {env} from '~/env.mjs';
import {prisma} from '~/server/db';

declare module 'next-auth' {
  interface Session {
    user:
      | ({
          id: string;
          canManageUsers: boolean;
        } & DefaultSession['user'])
      | undefined;
  }
}

export const authOptions: NextAuthOptions = {
  callbacks: {
    jwt: async ({token, user}) => {
      if (user) {
        token.id = user.id;
      }

      return token;
    },
    session: async ({session, token}) => {
      if (token && typeof token.id === 'string') {
        const user = await prisma.user.findUnique({
          where: {
            id: token.id,
          },
        });

        if (user) {
          session.user = {
            id: user.id,
            name: user.id,
            email: user.email,
            canManageUsers: user.canManageUsers,
          };
        } else {
          session.user = undefined;
        }
      }

      return session;
    },
  },
  providers: [
    Credentials({
      name: 'Credentials',
      credentials: {
        email: {type: 'email'},
        password: {type: 'password'},
      },
      authorize: async (credentials) => {
        const parsedCredentials = z
          .object({
            email: z.string().email(),
            password: z.string(),
          })
          .parse(credentials);

        const user = await prisma.user.findUnique({
          where: {
            email: parsedCredentials.email,
          },
        });

        if (!user || !(await bcrypt.compare(parsedCredentials.password, user.password))) {
          return null;
        }

        return user;
      },
    }),
  ],

  jwt: {
    maxAge: 30 * 24 * 60 * 60, // 30 days
  },
  secret: env.NEXTAUTH_SECRET,
};

export const getServerAuthSession = (ctx: {
  req: GetServerSidePropsContext['req'];
  res: GetServerSidePropsContext['res'];
}) => {
  return getServerSession(ctx.req, ctx.res, authOptions);
};
