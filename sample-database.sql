-- Sample database dump with Algerian cities
CREATE TABLE customers (
    id INT PRIMARY KEY,
    name VARCHAR(100),
    city VARCHAR(50),
    region VARCHAR(50),
    country VARCHAR(50)
);

INSERT INTO customers VALUES 
(1, 'Ahmed Hassan', 'Algiers', 'Algiers', 'Algeria'),
(2, 'Fatima Benali', 'Oran', 'Oran', 'Algeria'),
(3, 'Mohammed Kara', 'Constantine', 'Constantine', 'Algeria'),
(4, 'Leila Bouhali', 'Blida', 'Blida', 'Algeria'),
(5, 'Hassan Osman', 'Bouira', 'Bouira', 'Algeria');

CREATE TABLE locations (
    location_id INT PRIMARY KEY,
    address VARCHAR(200),
    city VARCHAR(50),
    region VARCHAR(50)
);

INSERT INTO locations VALUES
(101, '123 Rue de Algiers', 'Algiers', 'Algiers'),
(102, '456 Avenue Oran', 'Oran', 'Oran'),
(103, '789 Rue Constantine', 'Constantine', 'Constantine'),
(104, '321 Boulevard Tizi Ouzou', 'Tizi Ouzou', 'Tizi Ouzou'),
(105, '654 Chemin Sétif', 'Sétif', 'Sétif'),
(106, '987 Street Khenchela', 'Khenchela', 'Khenchela'),
(107, '147 Road Chlef', 'Chlef', 'Chlef');

-- Update queries
UPDATE customers SET city = 'Ouargla' WHERE id = 6;
UPDATE locations SET city = 'Ghardaia' WHERE location_id = 108;
