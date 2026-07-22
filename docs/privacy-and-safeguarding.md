# Privacy and safeguarding principles

PiensaPlay is designed for children. Safety and dignity take priority over analytics, growth mechanics or competition results.

## Product commitments

- No behavioural advertising, public profiles, direct messages or child-to-child contact.
- A nickname is sufficient; the game does not require a child's legal name.
- Flagship play and local progress do not require an account.
- Collect only data required for learning or continuity, and explain its purpose.
- Use aggregated learning evidence; do not rank or publicly compare individual children.
- Recovery codes are secrets, expire after 30 days and are invalidated after recovery.
- Firebase access follows least-privilege rules and user-owned data boundaries.

## Safeguarding in content

- Scenarios avoid graphic content and do not ask children to reopen traumatic events.
- Feedback explains consequences without shame, ridicule or fear-based manipulation.
- Threatening, sexual, self-harm or criminal content must be escalated to a trusted adult; children should not investigate it themselves.
- Correction is framed as care for a community, not punishment for making a mistake.

## Before production or a formal pilot

- Complete a child data protection impact assessment for each launch jurisdiction.
- Obtain legal review for consent, guardian notice, retention and deletion requirements.
- Publish a child-readable privacy notice and an adult policy in every supported language.
- Document breach response, safeguarding escalation and a contact for deletion requests.
- Deploy and test the repository's Firestore rules in the intended Firebase project.
- Replace development application identifiers and rotate any credentials previously shared outside the current team.

## Data retention proposal

Keep local learning progress until the learner resets the app. Keep optional cloud progress only while needed to provide recovery/synchronization. Delete expired recovery capsules automatically. For pilots, define a short retention window in the consent materials and delete row-level data after analysis; retain only non-identifying aggregates.

This document is a product standard, not jurisdiction-specific legal advice.
