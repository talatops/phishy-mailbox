-- ============================================
-- Phishy Mailbox Database Seed Data
-- Run this AFTER running supabase-migration.sql
-- Run this in Supabase SQL Editor
-- ============================================

-- Enable pgcrypto extension for password hashing
CREATE EXTENSION IF NOT EXISTS pgcrypto;

-- Insert Admin User
-- Password: 123456 (bcrypt hash with salt rounds 10)
-- Hash generated using: bcrypt.hash('123456', 10)
INSERT INTO "User" ("id", "email", "password", "created_at", "canManageUsers")
VALUES (
    gen_random_uuid(),
    'admin@example.com',
    '$2b$10$JZELVk3kqlO2m3GAxeCEAOufdEXKkrEfDorsxx5c1Dk0OisDPqHz2', -- bcrypt hash for '123456'
    CURRENT_TIMESTAMP,
    true
)
ON CONFLICT ("email") DO NOTHING;

-- Insert Sample Emails
INSERT INTO "Email" ("id", "senderMail", "senderName", "subject", "headers", "body", "allowExternalImages", "backofficeIdentifier")
VALUES 
    (
        gen_random_uuid(),
        'human@example.com',
        'Human',
        'Not-Phishing',
        'X-Header: Test',
        'Dies ist keine Phishing-Mail' || repeat('<br />', 200),
        false,
        'Not-Phishing'
    ),
    (
        gen_random_uuid(),
        'phish@example.com',
        'Phish',
        'Phishing',
        'X-Header: Test',
        'Dies ist eine Phishing-Mail <a href="https://example.com">Link</a>' || repeat('<br />', 200),
        false,
        'Phishing'
    ),
    (
        gen_random_uuid(),
        'human@example.com',
        'Human',
        'Scheduled mail',
        '',
        'Diese Mail wurde gescheduled, nach 5 Sekunden zu erscheinen.' || repeat('<br />', 200),
        false,
        'Scheduled'
    )
ON CONFLICT DO NOTHING;

-- Insert Study with Folders, Emails, and Participation
DO $$
DECLARE
    study_id UUID;
    folder1_id UUID;
    folder2_id UUID;
    folder3_id UUID;
    email_not_phishing_id UUID;
    email_phishing_id UUID;
    email_scheduled_id UUID;
    participation_id UUID;
BEGIN
    -- Create Study
    INSERT INTO "Study" (
        "id", "name", "startText", "endText", "durationInMinutes",
        "startLinkTemplate", "endLinkTemplate", "timerMode", "externalImageMode"
    )
    VALUES (
        gen_random_uuid(),
        'Teststudie',
        'Test-Beschreibung' || E'\n' || 'Hier könnte eine Beschreibung stehen oder auch eine kurze thematische Einführung.',
        'Test-Ende' || E'\n' || 'Hier könnte ein Text stehen, der die Teilnehmenden verabschiedet oder die nächsten Schritte erklärt.',
        10,
        'https://example.com/start/{code}',
        'https://example.com/end/{code}',
        'VISIBLE',
        'ASK'
    )
    RETURNING "id" INTO study_id;

    -- Create Folders (insert one at a time to capture IDs)
    INSERT INTO "Folder" ("id", "studyId", "name", "order")
    VALUES (gen_random_uuid(), study_id, 'Jetzt bearbeiten', 0)
    RETURNING "id" INTO folder1_id;
    
    INSERT INTO "Folder" ("id", "studyId", "name", "order")
    VALUES (gen_random_uuid(), study_id, 'Später bearbeiten', 1)
    RETURNING "id" INTO folder2_id;
    
    INSERT INTO "Folder" ("id", "studyId", "name", "order")
    VALUES (gen_random_uuid(), study_id, 'Junk', 2)
    RETURNING "id" INTO folder3_id;

    -- Get Email IDs
    SELECT "id" INTO email_not_phishing_id FROM "Email" WHERE "backofficeIdentifier" = 'Not-Phishing' LIMIT 1;
    SELECT "id" INTO email_phishing_id FROM "Email" WHERE "backofficeIdentifier" = 'Phishing' LIMIT 1;
    SELECT "id" INTO email_scheduled_id FROM "Email" WHERE "backofficeIdentifier" = 'Scheduled' LIMIT 1;

    -- Link Emails to Study
    IF email_not_phishing_id IS NOT NULL THEN
        INSERT INTO "StudyEmail" ("id", "studyId", "emailId", "order", "scheduledTime")
        VALUES (gen_random_uuid(), study_id, email_not_phishing_id, 0, 0)
        ON CONFLICT DO NOTHING;
    END IF;

    IF email_phishing_id IS NOT NULL THEN
        INSERT INTO "StudyEmail" ("id", "studyId", "emailId", "order", "scheduledTime")
        VALUES (gen_random_uuid(), study_id, email_phishing_id, 1, 0)
        ON CONFLICT DO NOTHING;
    END IF;

    IF email_scheduled_id IS NOT NULL THEN
        INSERT INTO "StudyEmail" ("id", "studyId", "emailId", "order", "scheduledTime")
        VALUES (gen_random_uuid(), study_id, email_scheduled_id, 2, 5)
        ON CONFLICT DO NOTHING;
    END IF;

    -- Create Participation
    INSERT INTO "Participation" ("id", "code", "studyId", "createdAt")
    VALUES (gen_random_uuid(), '123', study_id, CURRENT_TIMESTAMP)
    RETURNING "id" INTO participation_id;

END $$;

-- Update User password with proper bcrypt hash (if user already exists)
UPDATE "User" 
SET "password" = '$2b$10$JZELVk3kqlO2m3GAxeCEAOufdEXKkrEfDorsxx5c1Dk0OisDPqHz2' -- bcrypt hash for '123456'
WHERE "email" = 'admin@example.com';

