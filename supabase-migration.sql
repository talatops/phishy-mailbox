-- ============================================
-- Phishy Mailbox Database Schema Migration
-- Run this in Supabase SQL Editor
-- ============================================

-- Create Enums
CREATE TYPE "ExternalImageMode" AS ENUM ('SHOW', 'HIDE', 'ASK');
CREATE TYPE "TimerMode" AS ENUM ('DISABLED', 'HIDDEN', 'VISIBLE');

-- Create Email table
CREATE TABLE "Email" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "senderMail" TEXT NOT NULL,
    "senderName" TEXT NOT NULL,
    "subject" TEXT NOT NULL,
    "headers" TEXT NOT NULL,
    "body" TEXT NOT NULL,
    "allowExternalImages" BOOLEAN NOT NULL DEFAULT false,
    "backofficeIdentifier" TEXT NOT NULL,

    CONSTRAINT "Email_pkey" PRIMARY KEY ("id")
);

-- Create Study table
CREATE TABLE "Study" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "name" TEXT NOT NULL,
    "timerMode" "TimerMode" NOT NULL DEFAULT 'VISIBLE',
    "externalImageMode" "ExternalImageMode" NOT NULL DEFAULT 'ASK',
    "durationInMinutes" INTEGER,
    "openParticipation" BOOLEAN NOT NULL DEFAULT false,
    "consentRequired" BOOLEAN NOT NULL DEFAULT false,
    "consentText" TEXT,
    "startText" TEXT NOT NULL,
    "startLinkTemplate" TEXT,
    "endText" TEXT,
    "endLinkTemplate" TEXT,

    CONSTRAINT "Study_pkey" PRIMARY KEY ("id")
);

-- Create Folder table
CREATE TABLE "Folder" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "studyId" UUID NOT NULL,
    "name" TEXT NOT NULL,
    "order" INTEGER NOT NULL,

    CONSTRAINT "Folder_pkey" PRIMARY KEY ("id")
);

-- Create Participation table
CREATE TABLE "Participation" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "code" TEXT NOT NULL,
    "studyId" UUID NOT NULL,
    "createdAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,
    "codeUsedAt" TIMESTAMPTZ(3),
    "consentGivenAt" TIMESTAMPTZ(3),
    "startedAt" TIMESTAMPTZ(3),
    "finishedAt" TIMESTAMPTZ(3),
    "startLinkClickedAt" TIMESTAMPTZ(3),
    "endLinkClickedAt" TIMESTAMPTZ(3),

    CONSTRAINT "Participation_pkey" PRIMARY KEY ("id")
);

-- Create StudyEmail table
CREATE TABLE "StudyEmail" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "studyId" UUID NOT NULL,
    "emailId" UUID NOT NULL,
    "order" INTEGER NOT NULL DEFAULT 0,
    "scheduledTime" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "StudyEmail_pkey" PRIMARY KEY ("id")
);

-- Create ParticipationEmail table
CREATE TABLE "ParticipationEmail" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "participationId" UUID NOT NULL,
    "emailId" UUID NOT NULL,
    "folderId" UUID,
    "order" INTEGER NOT NULL DEFAULT 0,
    "scheduledTime" INTEGER NOT NULL DEFAULT 0,

    CONSTRAINT "ParticipationEmail_pkey" PRIMARY KEY ("id")
);

-- Create ParticipationEmailEvent table
CREATE TABLE "ParticipationEmailEvent" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "participationEmailId" UUID NOT NULL,
    "data" JSONB NOT NULL,
    "createdAt" TIMESTAMPTZ(3) NOT NULL DEFAULT CURRENT_TIMESTAMP,

    CONSTRAINT "ParticipationEmailEvent_pkey" PRIMARY KEY ("id")
);

-- Create User table
CREATE TABLE "User" (
    "id" UUID NOT NULL DEFAULT gen_random_uuid(),
    "email" TEXT NOT NULL,
    "password" TEXT NOT NULL,
    "created_at" TIMESTAMPTZ(3),
    "canManageUsers" BOOLEAN NOT NULL DEFAULT true,

    CONSTRAINT "User_pkey" PRIMARY KEY ("id")
);

-- Create Foreign Keys
ALTER TABLE "Folder" ADD CONSTRAINT "folder_study_id_study_id_fk" FOREIGN KEY ("studyId") REFERENCES "Study"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE "Participation" ADD CONSTRAINT "participation_study_id_study_id_fk" FOREIGN KEY ("studyId") REFERENCES "Study"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE "StudyEmail" ADD CONSTRAINT "study_email_study_id_study_id_fk" FOREIGN KEY ("studyId") REFERENCES "Study"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE "StudyEmail" ADD CONSTRAINT "study_email_email_id_email_id_fk" FOREIGN KEY ("emailId") REFERENCES "Email"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE "ParticipationEmail" ADD CONSTRAINT "participation_email_participation_id_participation_id_fk" FOREIGN KEY ("participationId") REFERENCES "Participation"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE "ParticipationEmail" ADD CONSTRAINT "participation_email_email_id_email_id_fk" FOREIGN KEY ("emailId") REFERENCES "Email"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE "ParticipationEmail" ADD CONSTRAINT "participation_email_folder_id_folder_id_fk" FOREIGN KEY ("folderId") REFERENCES "Folder"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

ALTER TABLE "ParticipationEmailEvent" ADD CONSTRAINT "participation_email_event_participation_email_id_fk" FOREIGN KEY ("participationEmailId") REFERENCES "ParticipationEmail"("id") ON DELETE NO ACTION ON UPDATE NO ACTION;

-- Create Unique Constraints
CREATE UNIQUE INDEX "code_idx" ON "Participation"("code");
CREATE UNIQUE INDEX "email_idx" ON "User"("email");
CREATE UNIQUE INDEX "StudyEmail_studyId_emailId_key" ON "StudyEmail"("studyId", "emailId");

-- Enable Row Level Security (optional, but good practice)
ALTER TABLE "Email" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "Study" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "Folder" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "Participation" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "StudyEmail" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "ParticipationEmail" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "ParticipationEmailEvent" ENABLE ROW LEVEL SECURITY;
ALTER TABLE "User" ENABLE ROW LEVEL SECURITY;

-- Create policies to allow all operations (adjust based on your security needs)
CREATE POLICY "Allow all operations on Email" ON "Email" FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all operations on Study" ON "Study" FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all operations on Folder" ON "Folder" FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all operations on Participation" ON "Participation" FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all operations on StudyEmail" ON "StudyEmail" FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all operations on ParticipationEmail" ON "ParticipationEmail" FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all operations on ParticipationEmailEvent" ON "ParticipationEmailEvent" FOR ALL USING (true) WITH CHECK (true);
CREATE POLICY "Allow all operations on User" ON "User" FOR ALL USING (true) WITH CHECK (true);

