CREATE TABLE IF NOT EXISTS esp_settings (
    id INT AUTO_INCREMENT PRIMARY KEY,
    player_id INT NOT NULL,
    esp_enabled BOOLEAN DEFAULT TRUE,
    esp_color VARCHAR(20) DEFAULT '255,0,0,200',
    esp_distance FLOAT DEFAULT 50.0,
    esp_size FLOAT DEFAULT 0.5,
    UNIQUE KEY unique_player (player_id)
);

INSERT INTO esp_settings (player_id, esp_enabled, esp_color, esp_distance, esp_size) 
SELECT player_id, TRUE, '255,0,0,200', 50.0, 0.5 FROM users WHERE player_id NOT IN (SELECT player_id FROM esp_settings);