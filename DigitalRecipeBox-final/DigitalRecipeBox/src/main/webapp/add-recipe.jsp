<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<jsp:include page="/WEB-INF/includes/header.jsp">
    <jsp:param name="title" value="Add New Recipe" />
</jsp:include>
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<div class="app-wrapper">
    <jsp:include page="/WEB-INF/includes/sidebar.jsp" />

    <main class="main-content">
        <div class="container-fluid">
            <!-- Header -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold mb-1"><i class="bi bi-plus-circle-fill text-success me-2"></i>Add New Recipe</h2>
                    <p class="text-muted mb-0">Fill in recipe details, ingredients, preparation steps, and nutrition values.</p>
                </div>
                <a href="${pageContext.request.contextPath}/recipes" class="btn btn-light border rounded-pill px-3">
                    <i class="bi bi-arrow-left me-1"></i> Back to Recipes
                </a>
            </div>

            <c:if test="${not empty errorMessage}">
                <div class="alert alert-danger alert-dismissible fade show mb-4" role="alert">
                    <i class="bi bi-exclamation-triangle-fill me-2"></i> ${errorMessage}
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <form action="${pageContext.request.contextPath}/add-recipe" method="POST">
                <div class="row g-4">
                    <!-- Left Column: Primary Details & Content -->
                    <div class="col-lg-8">
                        <div class="card border-0 shadow-sm rounded-4 p-4 bg-white mb-4">
                            <h5 class="fw-bold border-bottom pb-3 mb-4 text-dark"><i class="bi bi-info-circle me-2 text-success"></i>Basic Information</h5>
                            
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Recipe Name <span class="text-danger">*</span></label>
                                <input type="text" name="name" class="form-control form-control-lg" placeholder="e.g. Creamy Garlic Parmesan Pasta" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Short Description</label>
                                <textarea name="description" class="form-control" rows="2" placeholder="Brief appetizing description of the dish..."></textarea>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Ingredients (comma or newline separated) <span class="text-danger">*</span></label>
                                <textarea name="ingredients" class="form-control font-monospace" rows="5" placeholder="e.g.&#10;250g penne pasta&#10;2 tbsp olive oil&#10;4 cloves garlic minced&#10;1 cup heavy cream&#10;salt and black pepper" required></textarea>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Preparation & Cooking Steps <span class="text-danger">*</span></label>
                                <textarea name="instructions" class="form-control" rows="6" placeholder="1. Boil pasta in salted water until al dente.&#10;2. Saute garlic in olive oil over medium heat...&#10;3. Combine cream and cheese into smooth sauce." required></textarea>
                            </div>
                        </div>

                        <!-- Nutrition Card -->
                        <div class="card border-0 shadow-sm rounded-4 p-4 bg-white">
                            <h5 class="fw-bold border-bottom pb-3 mb-4 text-dark"><i class="bi bi-pie-chart me-2 text-warning"></i>Nutritional Facts (Per Serving)</h5>
                            
                            <div class="row g-3">
                                <div class="col-6 col-md-3">
                                    <label class="form-label fw-semibold text-muted small">Calories (kcal)</label>
                                    <input type="number" name="calories" class="form-control text-center fw-bold" placeholder="450" value="400">
                                </div>
                                <div class="col-6 col-md-3">
                                    <label class="form-label fw-semibold text-muted small">Protein (g)</label>
                                    <input type="number" step="0.1" name="proteinG" class="form-control text-center fw-bold" placeholder="25" value="15.0">
                                </div>
                                <div class="col-6 col-md-3">
                                    <label class="form-label fw-semibold text-muted small">Carbs (g)</label>
                                    <input type="number" step="0.1" name="carbsG" class="form-control text-center fw-bold" placeholder="50" value="50.0">
                                </div>
                                <div class="col-6 col-md-3">
                                    <label class="form-label fw-semibold text-muted small">Fat (g)</label>
                                    <input type="number" step="0.1" name="fatG" class="form-control text-center fw-bold" placeholder="15" value="12.0">
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Right Column: Settings, Category & Image -->
                    <div class="col-lg-4">
                        <div class="card border-0 shadow-sm rounded-4 p-4 bg-white mb-4">
                            <h5 class="fw-bold border-bottom pb-3 mb-4 text-dark"><i class="bi bi-sliders me-2 text-primary"></i>Metadata & Timings</h5>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Category <span class="text-danger">*</span></label>
                                <select name="categoryId" class="form-select" required>
                                    <c:forEach var="cat" items="${categories}">
                                        <option value="${cat.id}">${cat.name}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Difficulty Level</label>
                                <select name="difficulty" class="form-select">
                                    <option value="Easy">Easy</option>
                                    <option value="Medium" selected>Medium</option>
                                    <option value="Hard">Hard</option>
                                </select>
                            </div>

                            <div class="row g-2 mb-3">
                                <div class="col-6">
                                    <label class="form-label fw-semibold small">Prep Time (mins)</label>
                                    <input type="number" name="prepTimeMins" class="form-control" value="15">
                                </div>
                                <div class="col-6">
                                    <label class="form-label fw-semibold small">Cook Time (mins)</label>
                                    <input type="number" name="cookTimeMins" class="form-control" value="20">
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Servings</label>
                                <input type="number" name="servings" class="form-control" value="2">
                            </div>

                            <div class="mb-4">
                                <label class="form-label fw-semibold">Image URL or Path</label>
                                <input type="text" name="imageUrl" class="form-control" placeholder="https://images.unsplash.com/... or images/dishes/...">
                                <small class="text-muted">Paste web link or relative image path to recipe photo.</small>
                            </div>

                            <button type="submit" class="btn btn-emerald w-100 py-3 rounded-3 fw-bold">
                                <i class="bi bi-check-lg me-1"></i> Save & Publish Recipe
                            </button>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </main>
</div>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
