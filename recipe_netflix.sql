-- ============================================
-- RecipeFlix Database Setup
-- Database: recipe_netflix
-- ============================================

CREATE DATABASE IF NOT EXISTS recipe_netflix CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
USE recipe_netflix;

-- ============================================
-- Table: users
-- ============================================
CREATE TABLE IF NOT EXISTS users (
    id          INT AUTO_INCREMENT PRIMARY KEY,
    username    VARCHAR(50)  NOT NULL UNIQUE,
    password    VARCHAR(255) NOT NULL,   -- stores bcrypt hash (password_hash())
    created_at  TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- Table: recipes
-- ============================================
CREATE TABLE IF NOT EXISTS recipes (
    id           INT AUTO_INCREMENT PRIMARY KEY,
    title        VARCHAR(150) NOT NULL,
    description  TEXT,
    ingredients  TEXT,
    instructions TEXT,
    category     VARCHAR(80),
    image_url    VARCHAR(255) DEFAULT 'placeholder.jpg',
    cooking_time VARCHAR(50),                              -- e.g. "30 mins"
    difficulty   ENUM('Easy', 'Medium', 'Hard') DEFAULT 'Easy',
    created_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- Table: mylist  (user saved/bookmarked recipes)
-- Referenced by index.php nav link "My List"
-- ============================================
CREATE TABLE IF NOT EXISTS mylist (
    id         INT AUTO_INCREMENT PRIMARY KEY,
    user_id    INT NOT NULL,
    recipe_id  INT NOT NULL,
    saved_at   TIMESTAMP DEFAULT CURRENT_TIMESTAMP,
    UNIQUE KEY uq_user_recipe (user_id, recipe_id),
    FOREIGN KEY (user_id)   REFERENCES users(id)   ON DELETE CASCADE,
    FOREIGN KEY (recipe_id) REFERENCES recipes(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================
-- Seed: admin user
-- Password: password  (bcrypt hash below)
-- Change this password immediately in production!
-- ============================================
INSERT INTO users (username, password) VALUES
('admin', '$2y$10$92IXUNpkjO0rOQ5byMi.Ye4oKoEa3Ro9llC/.og/at2.uheWG/igi');

-- ============================================
-- Seed: sample recipes
-- ============================================
INSERT INTO recipes (title, description, ingredients, instructions, category, image_url, cooking_time, difficulty) VALUES

('Chocolate Lava Cake',
 'Decadent molten chocolate cake with a gooey center that flows when you cut into it.',
 '100g dark chocolate
100g unsalted butter
2 eggs
2 egg yolks
80g caster sugar
30g plain flour
Pinch of salt
Cocoa powder for dusting',
 '1. Preheat oven to 200°C (180°C fan). Grease 4 ramekins and dust with cocoa powder.
2. Melt chocolate and butter together in a bowl over simmering water. Stir until smooth.
3. Whisk eggs, egg yolks, and sugar together until pale and thick.
4. Fold the chocolate mixture into the egg mixture.
5. Sift in the flour and salt, fold gently until just combined.
6. Divide batter among ramekins. Refrigerate for at least 30 minutes.
7. Bake for 10–12 minutes until the edges are set but the centre still jiggles.
8. Rest for 1 minute, then invert onto plates and serve immediately.',
 'Dessert', 'img/lava-cake.jpg', '30 mins', 'Medium'),

('Spaghetti Carbonara',
 'A classic Roman pasta made with eggs, Pecorino Romano, guanciale, and black pepper.',
 '400g spaghetti
200g guanciale or pancetta, diced
4 egg yolks
1 whole egg
100g Pecorino Romano, finely grated
Freshly ground black pepper
Salt for pasta water',
 '1. Bring a large pot of salted water to a boil and cook spaghetti until al dente.
2. Meanwhile, fry guanciale in a dry pan over medium heat until crispy. Set aside with the rendered fat.
3. Whisk egg yolks, whole egg, and Pecorino together in a bowl. Season generously with pepper.
4. Reserve 1 cup of pasta water before draining.
5. Add drained pasta to the pan with the guanciale (off heat). Pour in the egg mixture.
6. Toss vigorously, adding pasta water a splash at a time until you have a creamy sauce.
7. Serve immediately with extra Pecorino and pepper.',
 'Italian', 'img/carbonara.jpg', '25 mins', 'Medium'),

('Classic Pancakes',
 'Fluffy, golden American-style pancakes perfect for a weekend breakfast.',
 '200g plain flour
2 tsp baking powder
1 tbsp sugar
Pinch of salt
2 eggs
300ml milk
2 tbsp melted butter
Butter or oil for frying',
 '1. Whisk flour, baking powder, sugar, and salt together in a bowl.
2. In a separate bowl, whisk eggs, milk, and melted butter.
3. Pour wet ingredients into dry and stir until just combined — a few lumps are fine.
4. Heat a non-stick pan over medium heat and lightly grease.
5. Pour about 80ml of batter per pancake. Cook until bubbles form on the surface (about 2 min).
6. Flip and cook for another 1–2 minutes until golden.
7. Serve with maple syrup, fresh fruit, or whipped cream.',
 'Breakfast', 'img/pancakes.jpg', '20 mins', 'Easy'),

('Butter Chicken',
 'Rich and creamy Indian curry with tender chicken in a tomato-based sauce.',
 '700g boneless chicken, cubed
1 cup plain yoghurt
2 tsp garam masala
1 tsp turmeric
2 tsp cumin
1 tsp chilli powder
3 tbsp butter
1 large onion, finely chopped
4 cloves garlic, minced
1 tbsp ginger, grated
400g tinned tomatoes
200ml heavy cream
Salt to taste
Fresh coriander to serve',
 '1. Marinate chicken in yoghurt, 1 tsp garam masala, turmeric, and chilli powder for at least 30 minutes.
2. Cook marinated chicken in a hot pan until charred at the edges. Set aside.
3. In the same pan, melt butter and sauté onion until golden.
4. Add garlic and ginger, cook for 2 minutes. Add remaining spices and stir for 1 minute.
5. Add tinned tomatoes and simmer for 15 minutes until thickened.
6. Blend the sauce until smooth, then return to the pan.
7. Add cooked chicken and cream. Simmer for 10 minutes.
8. Garnish with coriander and serve with naan or rice.',
 'Indian', 'img/butter-chicken.jpg', '50 mins', 'Medium'),

('Avocado Toast',
 'Simple, nutritious, and endlessly customisable — a modern breakfast staple.',
 '2 slices sourdough bread
1 ripe avocado
Juice of half a lemon
Salt and pepper
Red pepper flakes
2 eggs (optional)
Everything bagel seasoning (optional)',
 '1. Toast the sourdough until golden and crisp.
2. Halve the avocado, remove the stone, and scoop the flesh into a bowl.
3. Mash with lemon juice, salt, and pepper to your preferred texture.
4. Spread generously over the toast.
5. Top with red pepper flakes and bagel seasoning.
6. Optional: add a poached or fried egg on top.',
 'Breakfast', 'img/avocado-toast.jpg', '10 mins', 'Easy');
