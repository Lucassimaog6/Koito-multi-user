-- +goose Up

CREATE TABLE listens_new (
    track_id    INTEGER NOT NULL REFERENCES tracks(id) ON DELETE CASCADE,
    listened_at INTEGER NOT NULL,
    user_id     INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    client      TEXT NOT NULL DEFAULT '',
    PRIMARY KEY (track_id, listened_at, user_id)
);

INSERT INTO listens_new (track_id, listened_at, user_id, client)
SELECT track_id, listened_at, user_id, client
FROM listens;

DROP TABLE listens;
ALTER TABLE listens_new RENAME TO listens;

CREATE INDEX IF NOT EXISTS idx_listens_listened_at       ON listens(listened_at);
CREATE INDEX IF NOT EXISTS idx_listens_track_id          ON listens(track_id);
CREATE INDEX IF NOT EXISTS idx_listens_track_id_listened_at ON listens(track_id, listened_at);
CREATE INDEX IF NOT EXISTS idx_listens_user_id           ON listens(user_id);

-- +goose Down

CREATE TABLE listens_old (
    track_id    INTEGER NOT NULL REFERENCES tracks(id) ON DELETE CASCADE,
    listened_at INTEGER NOT NULL,
    user_id     INTEGER NOT NULL REFERENCES users(id) ON DELETE CASCADE,
    client      TEXT NOT NULL DEFAULT '',
    PRIMARY KEY (track_id, listened_at)
);

INSERT OR IGNORE INTO listens_old (track_id, listened_at, user_id, client)
SELECT track_id, listened_at, user_id, client
FROM listens
ORDER BY user_id ASC;

DROP TABLE listens;
ALTER TABLE listens_old RENAME TO listens;

CREATE INDEX IF NOT EXISTS idx_listens_listened_at       ON listens(listened_at);
CREATE INDEX IF NOT EXISTS idx_listens_track_id          ON listens(track_id);
CREATE INDEX IF NOT EXISTS idx_listens_track_id_listened_at ON listens(track_id, listened_at);
CREATE INDEX IF NOT EXISTS idx_listens_user_id           ON listens(user_id);
