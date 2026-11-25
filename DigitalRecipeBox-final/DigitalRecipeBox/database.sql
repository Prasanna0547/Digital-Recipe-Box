-- ============================================================
-- DIGITAL RECIPE BOX - DATABASE SCHEMA & SAMPLE DATA
-- Advanced Java Mini Project Database Script
-- ============================================================

CREATE DATABASE IF NOT EXISTS digital_recipe_box;
USE digital_recipe_box;

-- ------------------------------------------------------------
-- Table: users
-- ------------------------------------------------------------
DROP TABLE IF EXISTS favorites;
DROP TABLE IF EXISTS meal_plans;
DROP TABLE IF EXISTS shopping_lists;
DROP TABLE IF EXISTS recipes;
DROP TABLE IF EXISTS categories;
DROP TABLE IF EXISTS users;

CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY,
    username VARCHAR(50) NOT NULL UNIQUE,
    email VARCHAR(100) NOT NULL UNIQUE,
    password VARCHAR(255) NOT NULL, -- Hashed password
    full_name VARCHAR(100) NOT NULL,
    role VARCHAR(20) NOT NULL DEFAULT 'USER',
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------------
-- Table: categories
-- ------------------------------------------------------------
CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY,
    name VARCHAR(50) NOT NULL UNIQUE,
    description VARCHAR(255)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------------
-- Table: recipes
-- ------------------------------------------------------------
CREATE TABLE recipes (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    category_id INT NOT NULL,
    name VARCHAR(150) NOT NULL,
    description TEXT,
    ingredients TEXT NOT NULL,
    instructions TEXT NOT NULL,
    prep_time_mins INT DEFAULT 0,
    cook_time_mins INT DEFAULT 0,
    servings INT DEFAULT 1,
    difficulty VARCHAR(20) DEFAULT 'Medium', -- Easy, Medium, Hard
    image_url VARCHAR(500),
    calories INT DEFAULT 0,
    protein_g DOUBLE DEFAULT 0.0,
    carbs_g DOUBLE DEFAULT 0.0,
    fat_g DOUBLE DEFAULT 0.0,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_recipes_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_recipes_category FOREIGN KEY (category_id) REFERENCES categories(id) ON DELETE RESTRICT
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------------
-- Table: favorites
-- ------------------------------------------------------------
CREATE TABLE favorites (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    recipe_id INT NOT NULL,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_favorites_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_favorites_recipe FOREIGN KEY (recipe_id) REFERENCES recipes(id) ON DELETE CASCADE,
    UNIQUE KEY uk_user_recipe (user_id, recipe_id)
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------------
-- Table: meal_plans
-- ------------------------------------------------------------
CREATE TABLE meal_plans (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    recipe_id INT NOT NULL,
    meal_date DATE NOT NULL,
    meal_type VARCHAR(20) NOT NULL, -- Breakfast, Lunch, Dinner, Snack
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_meal_plans_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE,
    CONSTRAINT fk_meal_plans_recipe FOREIGN KEY (recipe_id) REFERENCES recipes(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ------------------------------------------------------------
-- Table: shopping_lists
-- ------------------------------------------------------------
CREATE TABLE shopping_lists (
    id INT AUTO_INCREMENT PRIMARY KEY,
    user_id INT NOT NULL,
    ingredient_name VARCHAR(150) NOT NULL,
    recipe_source VARCHAR(150) DEFAULT '',
    is_purchased BOOLEAN DEFAULT FALSE,
    created_at DATETIME DEFAULT CURRENT_TIMESTAMP,
    CONSTRAINT fk_shopping_lists_user FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4;

-- ============================================================
-- INSERT INITIAL SEED DATA
-- ============================================================

-- Categories
INSERT INTO categories (id, name, description) VALUES
(1, 'Breakfast', 'Morning energy boosters and classic breakfast dishes'),
(2, 'Lunch', 'Hearty and wholesome afternoon meals'),
(3, 'Dinner', 'Delicious evening recipes for family and friends'),
(4, 'Snacks', 'Quick bites, appetizers, and tea-time snacks'),
(5, 'Desserts', 'Sweet treats and decadent desserts'),
(6, 'Vegetarian', 'Plant-based vegetarian dishes packed with flavor'),
(7, 'Non-Vegetarian', 'Protein-rich meat, chicken, and seafood recipes'),
(8, 'Healthy', 'Low calorie, nutrient-dense, balanced healthy food');

-- Default Demo User (Password: demo123 -> SHA-256 hashed: 8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92)
INSERT INTO users (id, username, email, password, full_name) VALUES
(1, 'demo', 'demo@recipebox.com', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 'Chef Demo User'),
(2, 'sanjay', 'sanjay@recipebox.com', '8d969eef6ecad3c29a3a629280e686cf0c3f5d5a86aff3ca12020c923adc6c92', 'Sanjay Kumar');

-- Administrator demo account (Password: Admin@123)
INSERT INTO users (id, username, email, password, full_name, role) VALUES
(3, 'admin', 'admin@recipebox.com', 'e86f78a8a3caf0b60d8e74e5942aa6d86dc150cd3c03338aef25b7d2d7e3acc7', 'Recipe Box Admin', 'ADMIN');

-- 20 Sample Recipes
INSERT INTO recipes (id, user_id, category_id, name, description, ingredients, instructions, prep_time_mins, cook_time_mins, servings, difficulty, image_url, calories, protein_g, carbs_g, fat_g) VALUES
(1, 1, 7, 'Hyderabadi Chicken Biryani',
'A majestic fragrant rice dish layered with marinated chicken, aromatic spices, fried onions, and saffron.',
'chicken, basmati rice, yogurt, onion, ginger garlic paste, biryani masala, green chili, mint, coriander, ghee, saffron, salt',
'1. Marinate chicken with yogurt, ginger garlic paste, biryani masala, and green chili for 1 hour.\n2. Boil basmati rice with whole spices until 70% cooked, then drain.\n3. Fry thinly sliced onions in ghee until crisp and golden brown.\n4. Layer marinated chicken, fried onions, mint, coriander, and semi-cooked rice in a heavy pot.\n5. Drizzle ghee and warm saffron milk over top, seal tight, and cook on low dum heat for 30 minutes.',
30, 45, 4, 'Hard',
'images/dishes/hyderabadi-chicken-biryani.jpg',
650, 38.5, 68.0, 22.0),

(2, 1, 6, 'Vegetable Fried Rice',
'A quick and tasty Asian style fried rice loaded with crunchy fresh vegetables and savory soy sauce.',
'rice, carrot, capsicum, french beans, spring onion, garlic, soy sauce, vinegar, black pepper, cooking oil, salt',
'1. Cook basmati or jasmine rice and cool completely so grains stay separate.\n2. Heat oil in a hot wok and saute minced garlic for 30 seconds.\n3. Add finely chopped carrots, capsicum, and french beans; stir-fry on high flame for 2-3 minutes.\n4. Add cooled rice, soy sauce, vinegar, salt, and black pepper.\n5. Toss vigorously on high heat for 2 minutes and garnish with chopped spring onion greens.',
15, 15, 3, 'Easy',
'images/dishes/vegetable-fried-rice.jpg',
340, 7.5, 58.0, 9.0),

(3, 1, 1, 'Crispy Masala Dosa',
'Golden crispy fermented rice crepe stuffed with spiced mashed potato filling, served with coconut chutney.',
'dosa batter, potato, onion, green chili, mustard seeds, curry leaves, turmeric, oil, salt, coriander',
'1. Boil potatoes until tender, peel, and mash gently.\n2. Heat oil in a pan and splutter mustard seeds, curry leaves, and chopped green chili.\n3. Saute sliced onions until translucent, stir in turmeric, salt, and mashed potatoes.\n4. Spread dosa batter thinly in a spiral on a hot tawa and drizzle oil around edges until crisp.\n5. Place spiced potato masala in the center, fold, and serve piping hot.',
10, 20, 2, 'Medium',
'images/dishes/crispy-masala-dosa.jpg',
310, 6.0, 52.0, 9.5),

(4, 1, 1, 'Steamed Idli with Sambar',
'Soft fluffy steamed rice lentil cakes served with piping hot savory lentil vegetable stew.',
'idli batter, toor dal, drumstick, carrot, tomato, tamarind, sambar powder, mustard seeds, curry leaves, oil, salt',
'1. Grease idli molds lightly, pour fermented batter, and steam for 10-12 minutes until fluffy.\n2. Pressure cook toor dal with turmeric and water until soft and mashable.\n3. Simmer chopped carrots, drumsticks, and tomato in tamarind water with sambar powder and salt.\n4. Stir cooked dal into the vegetable stew and simmer for 5 minutes.\n5. Temper mustard seeds and curry leaves in oil, pour over sambar, and serve with warm idlis.',
15, 25, 3, 'Easy',
'images/dishes/steamed-idli-sambar.jpg',
260, 9.0, 48.0, 3.0),

(5, 1, 6, 'Tangy Tomato Rice',
'Flavorful South Indian rice dish tempered with mustard, curry leaves, ripe tomatoes, and aromatic spices.',
'rice, tomato, onion, mustard seeds, curry leaves, green chili, ginger, red chili powder, turmeric, ghee, salt',
'1. Heat ghee in a kadai and temper mustard seeds, curry leaves, slit green chili, and grated ginger.\n2. Add chopped onions and saute until soft and lightly golden.\n3. Add ripe chopped tomatoes, red chili powder, turmeric, and salt; cook until mushy and aromatic.\n4. Fold cooked rice gently into the spiced tomato masala until evenly coated.\n5. Garnish with fresh coriander leaves and serve with raita.',
10, 15, 2, 'Easy',
'images/dishes/tangy-tomato-rice.jpg',
290, 5.5, 49.0, 8.0),

(6, 1, 6, 'Paneer Butter Masala',
'Rich and creamy North Indian curry with soft cottage cheese cubes simmered in tomato cashew gravy.',
'paneer, tomato, onion, cashew, butter, cream, ginger garlic paste, garam masala, kasuri methi, red chili powder, salt',
'1. Simmer tomatoes, onions, and cashews until soft, then blend into a silky smooth puree.\n2. Melt butter in a pan and saute ginger garlic paste for 1 minute.\n3. Pour in the tomato-cashew puree with red chili powder and cook until butter separates.\n4. Add soft paneer cubes, garam masala, salt, and a splash of water; simmer for 5 minutes.\n5. Swirl in fresh cream and crushed kasuri methi before serving.',
20, 25, 3, 'Medium',
'images/dishes/paneer-butter-masala.jpg',
480, 18.0, 22.0, 36.0),

(7, 1, 7, 'Indo-Chinese Egg Fried Rice',
'Delicious fried rice scrambled with protein-rich eggs, veggies, and savory garlic dark soy seasoning.',
'rice, egg, onion, capsicum, carrot, spring onion, garlic, soy sauce, black pepper, oil, salt',
'1. Heat oil in a wok, scramble beaten eggs with salt and pepper, and set aside.\n2. In the same wok, saute minced garlic, chopped onions, carrots, and capsicum on high heat.\n3. Add cold cooked rice, scrambled eggs, soy sauce, and freshly cracked black pepper.\n4. Stir-fry briskly for 2-3 minutes so every grain gets smoky wok flavor.\n5. Top with sliced spring onions and serve hot.',
10, 15, 2, 'Easy',
'images/dishes/egg-fried-rice.jpg',
410, 15.0, 54.0, 14.0),

(8, 1, 8, 'Wholesome Vegetable Soup',
'A soothing low-calorie soup made with fresh garden vegetables, herbs, and garlic broth.',
'carrot, cabbage, sweet corn, french beans, garlic, onion, butter, black pepper, vegetable stock, salt, cornstarch',
'1. Melt butter in a soup pot and saute minced garlic and chopped onions until fragrant.\n2. Add finely diced carrots, cabbage, french beans, and sweet corn; saute for 2 minutes.\n3. Pour in vegetable stock and bring the soup to a gentle boil.\n4. Season with salt and black pepper, then stir in a light cornstarch slurry.\n5. Simmer for 8-10 minutes until vegetables are tender and serve warm.',
15, 20, 4, 'Easy',
'images/dishes/wholesome-vegetable-soup.jpg',
160, 4.0, 26.0, 4.5),

(9, 1, 3, 'Penne Pasta Arrabbiata',
'Classic Italian penne pasta tossed in a spicy garlic tomato sauce with olive oil and parmesan cheese.',
'penne pasta, tomato, garlic, olive oil, chili flakes, oregano, basil, parmesan cheese, salt',
'1. Boil penne pasta in salted water until al dente, then drain and reserve half a cup of pasta water.\n2. Warm extra-virgin olive oil in a skillet and gently sizzle sliced garlic and red chili flakes.\n3. Pour in crushed tomatoes, dried oregano, and salt; simmer 10 minutes until rich and thick.\n4. Toss boiled penne into the sauce with a splash of reserved pasta water.\n5. Finish with torn fresh basil leaves and grated parmesan cheese.',
10, 20, 2, 'Easy',
'images/dishes/penne-pasta-arrabbiata.jpg',
420, 12.0, 64.0, 12.0),

(10, 1, 5, 'Fresh Tropical Fruit Salad',
'Refreshing salad composed of sweet mango, strawberry, kiwi, pineapple, and honey lime drizzle.',
'mango, strawberry, kiwi, pineapple, apple, banana, honey, lime juice, mint',
'1. Peel and dice mango, kiwi, pineapple, apple, and banana into uniform bite-sized cubes.\n2. Hull and halve fresh strawberries.\n3. Whisk pure honey and freshly squeezed lime juice in a small bowl.\n4. Combine all fruits in a chilled salad bowl, drizzle the dressing, and toss gently.\n5. Garnish with fresh mint leaves and serve chilled.',
15, 0, 4, 'Easy',
'images/dishes/fresh-tropical-fruit-salad.jpg',
180, 2.0, 44.0, 0.8),

(11, 1, 3, 'Creamy Mushroom Risotto',
'A comforting Italian rice dish slowly cooked with mushrooms, stock, parmesan, and fresh herbs.',
'arborio rice, mushrooms, vegetable stock, onion, garlic, butter, olive oil, parmesan, parsley, salt, black pepper',
'1. Warm vegetable stock in a saucepan and keep it at a gentle simmer.\n2. Cook chopped onion and sliced mushrooms in butter and olive oil until golden and tender.\n3. Stir in arborio rice and minced garlic; toast for 1 minute.\n4. Add warm stock one ladle at a time, stirring frequently until absorbed before adding more.\n5. Once creamy and al dente, stir in grated parmesan cheese and fresh chopped parsley.',
10, 30, 3, 'Medium',
'images/dishes/creamy-mushroom-risotto.jpg',
390, 12.0, 58.0, 12.0),

(12, 1, 2, 'Avocado Chickpea Salad',
'A fresh, filling salad with creamy avocado, chickpeas, crunchy vegetables, and lemon dressing.',
'chickpeas, avocado, cucumber, cherry tomatoes, red onion, lemon juice, olive oil, parsley, salt, black pepper',
'1. Drain and rinse cooked chickpeas thoroughly, then transfer to a large mixing bowl.\n2. Dice ripe avocado and cucumber, halve cherry tomatoes, and thinly slice red onion.\n3. Whisk lemon juice, olive oil, salt, and black pepper to create a zesty dressing.\n4. Gently fold the vegetables, avocado, and chickpeas together with the dressing.\n5. Top with chopped fresh parsley and serve immediately.',
15, 0, 2, 'Easy',
'images/dishes/avocado-chickpea-salad.jpg',
320, 10.0, 34.0, 17.0),

(13, 1, 7, 'Grilled Lemon Herb Salmon',
'Tender salmon fillets grilled with lemon, garlic, and herbs for a quick weeknight dinner.',
'salmon fillets, lemon, garlic, olive oil, parsley, dill, salt, black pepper',
'1. Pat salmon fillets dry with paper towels and arrange on a lightly oiled grill tray.\n2. Mix olive oil, minced garlic, chopped parsley, dill, salt, and black pepper.\n3. Brush the herb-garlic marinade generously over the salmon and top with lemon slices.\n4. Grill for 8-12 minutes until the salmon flakes easily with a fork.\n5. Serve hot with fresh lemon wedges and extra herbs.',
10, 12, 2, 'Easy',
'images/dishes/grilled-lemon-herb-salmon.jpg',
430, 38.0, 8.0, 27.0),

(14, 1, 5, 'Chocolate Lava Cake',
'Individual chocolate cakes with a warm, rich molten centre, best served straight from the oven.',
'dark chocolate, butter, egg, sugar, flour, cocoa powder, vanilla extract, salt',
'1. Preheat oven to 220 C and butter two small oven-safe ramekins, dusting lightly with cocoa powder.\n2. Melt dark chocolate and butter together gently, then let cool slightly.\n3. Whisk eggs and sugar until thick and pale, then fold in melted chocolate and vanilla.\n4. Fold in flour, cocoa powder, and a pinch of salt; divide evenly into ramekins.\n5. Bake for 10-12 minutes until edges are set while centers remain soft and molten.',
15, 12, 2, 'Medium',
'images/dishes/chocolate-lava-cake.jpg',
510, 8.0, 55.0, 31.0),

(15, 1, 1, 'Blueberry Banana Pancakes',
'Fluffy pancakes folded with ripe banana and blueberries for a bright breakfast treat.',
'flour, milk, egg, banana, blueberries, baking powder, sugar, butter, salt',
'1. Whisk flour, baking powder, sugar, and salt together in a mixing bowl.\n2. In a separate bowl, mash ripe banana smooth and whisk with milk and egg.\n3. Stir wet mixture into dry ingredients until just combined, then gently fold in blueberries.\n4. Pour ladlefuls onto a buttered griddle over medium heat; flip when bubbles form and cook until golden.\n5. Stack warm pancakes and top with fresh blueberries and maple syrup.',
10, 15, 4, 'Easy',
'images/dishes/blueberry-banana-pancakes.jpg',
350, 10.0, 57.0, 10.0),

(16, 1, 7, 'Classic Butter Chicken',
'Succulent tandoori-spiced chicken simmered in a velvety spiced tomato butter sauce.',
'chicken, tomato, butter, cream, yogurt, ginger garlic paste, garam masala, red chili powder, kasuri methi, salt',
'1. Marinate chicken pieces in yogurt, ginger garlic paste, chili powder, and salt for 30 minutes.\n2. Sear marinated chicken in a hot skillet until lightly charred and set aside.\n3. Melt butter in the pan, simmer pureed tomatoes with spices until thick and rich.\n4. Return seared chicken to the gravy and simmer for 12 minutes until tender.\n5. Stir in fresh cream and crushed kasuri methi; serve hot with naan or rice.',
25, 30, 4, 'Medium',
'images/dishes/classic-butter-chicken.jpg',
540, 34.0, 16.0, 37.0),

(17, 1, 3, 'Margherita Wood-Fired Pizza',
'Crisp hand-stretched crust topped with San Marzano tomato sauce, fresh mozzarella, and sweet basil.',
'pizza dough, tomato sauce, mozzarella cheese, basil, olive oil, garlic, oregano, salt',
'1. Preheat oven with a pizza stone or baking sheet to 240 C for 15 minutes.\n2. Stretch rested pizza dough on a floured surface into a thin 12-inch circle.\n3. Spread seasoned crushed tomato sauce evenly over the dough, leaving a border.\n4. Arrange sliced fresh mozzarella and drizzle lightly with extra-virgin olive oil.\n5. Bake for 10-12 minutes until crust is blistered and golden, then scatter fresh basil leaves.',
20, 12, 2, 'Medium',
'images/dishes/margherita-pizza.jpg',
460, 19.0, 56.0, 18.0),

(18, 1, 4, 'Crispy Samosa Chaat',
'Crunchy spiced potato samosas crushed and layered with yogurt, tamarind chutney, mint chutney, and sev.',
'samosa, yogurt, chickpea curry, tamarind chutney, mint chutney, onion, tomato, sev, chaat masala, coriander',
'1. Warm crispy samosas and lightly crush them into bite-sized pieces on a serving plate.\n2. Spoon hot spiced chickpea curry evenly over the crushed samosas.\n3. Drizzle whisked chilled yogurt, sweet tamarind chutney, and spicy green mint chutney.\n4. Scatter finely chopped red onions, tomatoes, and a pinch of chaat masala.\n5. Top generously with crunchy sev and fresh coriander leaves; serve right away.',
10, 10, 2, 'Easy',
'images/dishes/crispy-samosa-chaat.jpg',
380, 9.0, 50.0, 16.0),

(19, 1, 8, 'Greek Quinoa Power Bowl',
'Nutrient-packed Mediterranean bowl with fluffy quinoa, crisp veggies, olives, feta, and lemon herb dressing.',
'quinoa, cucumber, cherry tomatoes, olives, feta cheese, red onion, olive oil, lemon juice, oregano, salt',
'1. Rinse quinoa thoroughly and simmer in water for 15 minutes until light and fluffy.\n2. Dice cucumber, halve cherry tomatoes, and slice red onion and kalamata olives.\n3. Whisk olive oil, lemon juice, dried oregano, and salt for the Greek vinaigrette.\n4. Arrange cooled quinoa in bowls and top neatly with fresh vegetables and crumbled feta.\n5. Drizzle lemon herb dressing over the bowl and serve.',
15, 15, 2, 'Easy',
'images/dishes/greek-quinoa-bowl.jpg',
360, 13.0, 42.0, 15.0),

(20, 1, 5, 'Warm Gulab Jamun',
'Melt-in-the-mouth golden milk dumplings soaked in fragrant cardamom rose sugar syrup.',
'milk powder, flour, ghee, milk, sugar, cardamom, rose water, pistachio, oil',
'1. Boil sugar and water with crushed cardamom pods for 8 minutes until sticky; add rose water.\n2. Mix milk powder, flour, and melted ghee; knead gently with warm milk into a soft dough.\n3. Roll dough into smooth crack-free small spheres.\n4. Deep-fry spheres in warm ghee or oil on low heat, turning gently until deep golden brown.\n5. Soak warm gulab jamuns in warm syrup for 1 hour and garnish with chopped pistachios.',
20, 25, 4, 'Medium',
'images/dishes/warm-gulab-jamun.jpg',
340, 6.0, 56.0, 11.0);

-- Initial Favorites for Demo user
INSERT INTO favorites (user_id, recipe_id) VALUES 
(1, 1),
(1, 3),
(1, 6);

-- Initial Meal Plans for Demo User
INSERT INTO meal_plans (user_id, recipe_id, meal_date, meal_type) VALUES
(1, 3, CURRENT_DATE(), 'Breakfast'),
(1, 1, CURRENT_DATE(), 'Lunch'),
(1, 8, CURRENT_DATE(), 'Dinner'),
(1, 4, DATE_ADD(CURRENT_DATE(), INTERVAL 1 DAY), 'Breakfast'),
(1, 7, DATE_ADD(CURRENT_DATE(), INTERVAL 1 DAY), 'Lunch');

-- Initial Shopping Items for Demo User
INSERT INTO shopping_lists (user_id, ingredient_name, recipe_source, is_purchased) VALUES
(1, 'chicken', 'Hyderabadi Chicken Biryani', FALSE),
(1, 'basmati rice', 'Hyderabadi Chicken Biryani', TRUE),
(1, 'paneer', 'Paneer Butter Masala', FALSE),
(1, 'cream', 'Paneer Butter Masala', FALSE),
(1, 'fresh mint', 'Fresh Tropical Fruit Salad', TRUE);
