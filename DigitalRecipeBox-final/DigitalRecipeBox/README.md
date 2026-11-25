# Digital Recipe Box 🍳📖
> **Academic Advanced Java Mini Project**

Digital Recipe Box is a feature-rich, modern, responsive web application designed for users to store, organize, search, manage, and discover recipes digitally. Built strictly using core **Advanced Java technologies** (Servlets, JSP, JDBC, MySQL, MVC Architecture, DAO Pattern, and PreparedStatement), it includes advanced capabilities like **Meal Planning**, **Automatic Shopping List Generation**, **Nutritional Tracking**, and a practical **Smart Ingredient-Based Recipe Recommendation Algorithm**.

---

## 🌟 Key Features

1. **User Management & Authentication**:
   - Secure Registration & Login with SHA-256 password hashing.
   - Separate administrator sign-in with role-based access to the complete recipe catalogue.
   - Session-based authentication via `HttpSession` and Jakarta `AuthFilter`.
   - User profile management & password modification.

2. **Recipe CRUD Management**:
   - Complete CRUD operations (Add, View, Edit, Delete).
   - Rich recipe cards with metadata (prep time, cook time, servings, difficulty badge, category, calories).
   - Responsive recipe details page with checkable ingredient lists and step-by-step instructions.

3. **Search, Filter & Category Catalogue**:
   - Live search by recipe title, description, or ingredients.
   - Filter by Category (Breakfast, Lunch, Dinner, Snacks, Desserts, Vegetarian, Non-Vegetarian, Healthy).
   - Filter by Difficulty (Easy, Medium, Hard) and Maximum Cooking Time.
   - Dynamic sorting (Newest, Name A-Z, Cooking Time, Calories).

4. **Weekly & Daily Meal Planner**:
   - Schedule meals for specific dates across Breakfast, Lunch, Dinner, and Snacks.
   - Interactive schedule calendar cards.

5. **Automatic Shopping List Generator**:
   - Collects ingredients from scheduled meal plans and populates a digital grocery checklist.
   - Supports adding custom shopping items.
   - Interactive checkbox state toggle (Purchased vs Pending).
   - One-click clear completed/clear all features.

6. **Smart Ingredient Matcher (AI Recommendation Engine)**:
   - Practical ingredient matching algorithm.
   - Input available pantry items (e.g. `rice, tomato, onion, egg`).
   - Calculates exact matching percentage ($Match = \frac{\text{Matched Ingredients}}{\text{Total Recipe Ingredients}} \times 100\%$).
   - Highlights available ingredients in green and missing ingredients in red.
   - Sorts recommendations by highest match score.

7. **Nutritional Information Module**:
   - Displays Calories (kcal), Protein (g), Carbohydrates (g), and Fat (g) in styled nutrition cards.

8. **Favorites Collection**:
   - One-click favorite toggling for quick recipe bookmarking.

---

## 🛠 Technology Stack

- **Backend**: Java 17+, Jakarta Servlet API 6.0, Jakarta JSP 3.1, JSTL 3.0, JDBC (PreparedStatement), MySQL.
- **Architecture**: MVC Pattern (Model-View-Controller), DAO Pattern (Data Access Object), Servlet Filters.
- **Frontend**: HTML5, CSS3 (Modern Glassmorphism & Custom Design System), Bootstrap 5.3, Bootstrap Icons, JavaScript (ES6).
- **Database**: MySQL Server (`digital_recipe_box`).
- **Web Server**: Apache Tomcat 10+ (Jakarta EE compatible).
- **Build Tool**: Apache Maven (`pom.xml`).

---

## 📁 Project Architecture & Structure

```
DigitalRecipeBox/
├── pom.xml                        # Maven dependencies & build configuration
├── database.sql                   # MySQL database schema & 15 sample recipes
├── README.md                      # Comprehensive project documentation
└── src/
    └── main/
        ├── java/
        │   └── com/digitalrecipebox/
        │       ├── controller/    # Servlets (Register, Login, Recipe, MealPlan, etc.)
        │       ├── dao/           # Data Access Objects (UserDAO, RecipeDAO, etc.)
        │       ├── filter/        # Jakarta WebFilters (AuthFilter)
        │       ├── model/         # Entity JavaBeans (User, Recipe, MealPlan, etc.)
        │       ├── service/       # Business Logic (RecommendationService)
        │       └── util/          # Utilities (DBConnection, PasswordUtil)
        │
        ├── resources/
        │   └── db.properties      # Database connection configuration
        │
        └── webapp/
            ├── WEB-INF/
            │   ├── web.xml        # Deployment descriptor
            │   └── includes/      # JSP includes (header, navbar, footer, sidebar)
            ├── css/               # Modern stylesheet (style.css)
            ├── js/                # Client JavaScript (main.js)
            └── JSP Pages          # (index, login, register, dashboard, recipes, etc.)
```

---

## 🗄 Database Configuration (`database.sql`)

The application requires a MySQL database named `digital_recipe_box`.

### Tables Included:
- `users`: User accounts with hashed passwords.
- `categories`: Master recipe categories.
- `recipes`: Core recipe details, timings, image URLs, and nutrition breakdown.
- `favorites`: User favorited recipes.
- `meal_plans`: Scheduled breakfast/lunch/dinner meals.
- `shopping_lists`: Auto-generated and custom grocery items.

---

## 🚀 How to Setup, Build, and Run

### 1. Database Setup
1. Open MySQL Command Line Client or Workbench.
2. Run the script provided in `database.sql`:
   ```sql
   SOURCE <path-to-project>/database.sql;
   ```
3. Update `src/main/resources/db.properties` with your MySQL credentials:
   ```properties
   db.driver=com.mysql.cj.jdbc.Driver
   db.url=jdbc:mysql://localhost:3306/digital_recipe_box?useSSL=false&allowPublicKeyRetrieval=true&serverTimezone=UTC
   db.user=root
   db.password=YOUR_MYSQL_PASSWORD
   ```

### 2. Maven Build Command
Open command prompt or terminal in the project root directory and build the WAR file:
```cmd
mvn clean package
```
*Output WAR file location:* `target/DigitalRecipeBox.war`

### 3. Deployment to Apache Tomcat 10+
1. Copy the generated `DigitalRecipeBox.war` file to Apache Tomcat's `webapps/` folder.
   - Example: `C:\apache-tomcat-10.1.x\webapps\DigitalRecipeBox.war`
2. Start Apache Tomcat:
   - On Windows: Open Command Prompt, navigate to Tomcat `bin/` directory, and execute `startup.bat`.
     ```cmd
     cd C:\apache-tomcat-10.1.x\bin
     startup.bat
     ```
3. Open your browser and navigate to:
   ```
   http://localhost:8080/DigitalRecipeBox/
   ```

---

## 🔑 Default Credentials for Demonstration

- **Username**: `demo`
- **Password**: `demo123`

*(You can also register a new account on `register.jsp`)*

### Administrator Demo Login

- **Sign-in page**: `http://localhost:8080/DigitalRecipeBox/admin/login`
- **Username**: `admin`
- **Password**: `Admin@123`

The database script seeds 15 illustrated dishes with preparation steps. It drops and recreates the application tables, so back up existing data before running it.

---

## 🎯 Complete 20-Step Project Demonstration Flow

1. **Open Landing Page** (`index.jsp`) -> Explores project highlights & features.
2. **Register New User** (`register.jsp`) -> Tests validation & unique constraints.
3. **Login** (`login.jsp`) -> Tests SHA-256 authentication & session start.
4. **Dashboard** (`dashboard.jsp`) -> Displays aggregate statistics & quick action toolbar.
5. **Add Recipe** (`add-recipe.jsp`) -> Saves a new dish with nutrition metrics into MySQL.
6. **View Recipe Details** (`recipe-details.jsp`) -> Inspects ingredients checklist & nutrition cards.
7. **Edit Recipe** (`edit-recipe.jsp`) -> Updates recipe timings and preparation steps.
8. **Delete Recipe** -> Confirms deletion via modal dialog.
9. **Search Recipes** (`recipes.jsp`) -> Tests real-time search by recipe name or ingredient.
10. **Filter Recipes** -> Filters by category (e.g., Breakfast, Lunch, Healthy) and cook time.
11. **Favorite Recipe** -> Toggles heart button on recipe card.
12. **View Favorites** (`favorites.jsp`) -> Views favorited recipes collection.
13. **Schedule Meal Plan** (`meal-planner.jsp`) -> Assigns a recipe to a specific date & meal type.
14. **Generate Shopping List** -> Click "Sync Meal Plan Ingredients".
15. **Manage Shopping List** (`shopping-list.jsp`) -> Marks items as purchased, adds custom item.
16. **Open Smart Recommendation Engine** (`recommendations.jsp`).
17. **Input Pantry Ingredients** -> Enters `rice, tomato, onion, egg`.
18. **Get AI Match Results** -> Analyzes percentage match badges, green matched tags, and red missing tags.
19. **View Profile** (`profile.jsp`) -> Changes full name or updates security password.
20. **Logout** (`logout`) -> Invalidates HTTP Session cleanly.

---

## 🔮 Future Enhancements
- Export Shopping List as PDF/Printable document.
- Social recipe sharing & user reviews.
- Calorie counting tracker based on meal plans.
