<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<jsp:include page="/WEB-INF/includes/header.jsp">
    <jsp:param name="title" value="Edit Recipe" />
</jsp:include>
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<div class="app-wrapper">
    <jsp:include page="/WEB-INF/includes/sidebar.jsp" />

    <main class="main-content">
        <div class="container-fluid">
            <!-- Header -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold mb-1"><i class="bi bi-pencil-square text-primary me-2"></i>Edit Recipe</h2>
                    <p class="text-muted mb-0">Update recipe details for "${recipe.name}"</p>
                </div>
                <div class="d-flex gap-2">
                    <a href="${pageContext.request.contextPath}/recipe?id=${recipe.id}" class="btn btn-light border rounded-pill px-3">
                        <i class="bi bi-x-lg me-1"></i> Cancel
                    </a>
                </div>
            </div>

            <form action="${pageContext.request.contextPath}/edit-recipe" method="POST">
                <input type="hidden" name="id" value="${recipe.id}">

                <div class="row g-4">
                    <div class="col-lg-8">
                        <div class="card border-0 shadow-sm rounded-4 p-4 bg-white mb-4">
                            <h5 class="fw-bold border-bottom pb-3 mb-4 text-dark"><i class="bi bi-info-circle me-2 text-success"></i>Basic Information</h5>
                            
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Recipe Name <span class="text-danger">*</span></label>
                                <input type="text" name="name" class="form-control form-control-lg" value="${recipe.name}" required>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Short Description</label>
                                <textarea name="description" class="form-control" rows="2">${recipe.description}</textarea>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Ingredients (comma or newline separated) <span class="text-danger">*</span></label>
                                <textarea name="ingredients" class="form-control font-monospace" rows="5" required>${recipe.ingredients}</textarea>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Preparation & Cooking Steps <span class="text-danger">*</span></label>
                                <textarea name="instructions" class="form-control" rows="6" required>${recipe.instructions}</textarea>
                            </div>
                        </div>

                        <!-- Nutrition Card -->
                        <div class="card border-0 shadow-sm rounded-4 p-4 bg-white">
                            <h5 class="fw-bold border-bottom pb-3 mb-4 text-dark"><i class="bi bi-pie-chart me-2 text-warning"></i>Nutritional Facts (Per Serving)</h5>
                            
                            <div class="row g-3">
                                <div class="col-6 col-md-3">
                                    <label class="form-label fw-semibold text-muted small">Calories (kcal)</label>
                                    <input type="number" name="calories" class="form-control text-center fw-bold" value="${recipe.calories}">
                                </div>
                                <div class="col-6 col-md-3">
                                    <label class="form-label fw-semibold text-muted small">Protein (g)</label>
                                    <input type="number" step="0.1" name="proteinG" class="form-control text-center fw-bold" value="${recipe.proteinG}">
                                </div>
                                <div class="col-6 col-md-3">
                                    <label class="form-label fw-semibold text-muted small">Carbs (g)</label>
                                    <input type="number" step="0.1" name="carbsG" class="form-control text-center fw-bold" value="${recipe.carbsG}">
                                </div>
                                <div class="col-6 col-md-3">
                                    <label class="form-label fw-semibold text-muted small">Fat (g)</label>
                                    <input type="number" step="0.1" name="fatG" class="form-control text-center fw-bold" value="${recipe.fatG}">
                                </div>
                            </div>
                        </div>
                    </div>

                    <!-- Right Column: Settings -->
                    <div class="col-lg-4">
                        <div class="card border-0 shadow-sm rounded-4 p-4 bg-white mb-4">
                            <h5 class="fw-bold border-bottom pb-3 mb-4 text-dark"><i class="bi bi-sliders me-2 text-primary"></i>Metadata & Timings</h5>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Category <span class="text-danger">*</span></label>
                                <select name="categoryId" class="form-select" required>
                                    <c:forEach var="cat" items="${categories}">
                                        <option value="${cat.id}" ${recipe.categoryId == cat.id ? 'selected' : ''}>${cat.name}</option>
                                    </c:forEach>
                                </select>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Difficulty Level</label>
                                <select name="difficulty" class="form-select">
                                    <option value="Easy" ${recipe.difficulty == 'Easy' ? 'selected' : ''}>Easy</option>
                                    <option value="Medium" ${recipe.difficulty == 'Medium' ? 'selected' : ''}>Medium</option>
                                    <option value="Hard" ${recipe.difficulty == 'Hard' ? 'selected' : ''}>Hard</option>
                                </select>
                            </div>

                            <div class="row g-2 mb-3">
                                <div class="col-6">
                                    <label class="form-label fw-semibold small">Prep Time (mins)</label>
                                    <input type="number" name="prepTimeMins" class="form-control" value="${recipe.prepTimeMins}">
                                </div>
                                <div class="col-6">
                                    <label class="form-label fw-semibold small">Cook Time (mins)</label>
                                    <input type="number" name="cookTimeMins" class="form-control" value="${recipe.cookTimeMins}">
                                </div>
                            </div>

                            <div class="mb-3">
                                <label class="form-label fw-semibold">Servings</label>
                                <input type="number" name="servings" class="form-control" value="${recipe.servings}">
                            </div>

                            <div class="mb-4">
                                <label class="form-label fw-semibold">Image URL or Path</label>
                                <input type="text" name="imageUrl" class="form-control" value="${recipe.imageUrl}">
                            </div>

                            <button type="submit" class="btn btn-emerald w-100 py-3 rounded-3 fw-bold mb-2">
                                <i class="bi bi-save me-1"></i> Update Recipe
                            </button>
                        </div>
                    </div>
                </div>
            </form>
        </div>
    </main>
</div>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
