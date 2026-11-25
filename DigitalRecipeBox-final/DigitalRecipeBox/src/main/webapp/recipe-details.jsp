<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<jsp:include page="/WEB-INF/includes/header.jsp">
    <jsp:param name="title" value="${recipe.name}" />
</jsp:include>
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<div class="app-wrapper">
    <jsp:include page="/WEB-INF/includes/sidebar.jsp" />

    <main class="main-content">
        <div class="container-fluid">
            
            <!-- Messages -->
            <c:if test="${param.msg == 'added'}">
                <div class="alert alert-success alert-dismissible fade show mb-4" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i> Recipe created successfully!
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>
            <c:if test="${param.msg == 'updated'}">
                <div class="alert alert-info alert-dismissible fade show mb-4" role="alert">
                    <i class="bi bi-info-circle-fill me-2"></i> Recipe updated successfully!
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Hero Image Banner -->
            <div class="card border-0 shadow-sm rounded-4 overflow-hidden mb-4 bg-white">
                <div class="row g-0">
                    <div class="col-lg-6">
                        <img src="${recipe.imageUrl}" alt="${recipe.name}" class="w-100 h-100"
                             style="min-height: 350px; max-height: 450px; object-fit: cover;"
                             onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/images/default-dish.svg';">
                    </div>
                    <div class="col-lg-6 p-4 p-lg-5 d-flex flex-column justify-content-between">
                        <div>
                            <div class="d-flex justify-content-between align-items-center mb-2">
                                <div class="d-flex align-items-center gap-2">
                                    <span class="badge bg-success bg-opacity-10 text-success fw-bold px-3 py-2 rounded-pill">
                                        ${recipe.categoryName}
                                    </span>
                                    <span class="badge ${recipe.difficulty == 'Easy' ? 'badge-easy' : (recipe.difficulty == 'Hard' ? 'badge-hard' : 'badge-medium')} px-3 py-2 rounded-pill">
                                        ${recipe.difficulty}
                                    </span>
                                </div>
                                
                                <form action="${pageContext.request.contextPath}/favorite" method="POST" class="d-inline">
                                    <input type="hidden" name="recipeId" value="${recipe.id}">
                                    <input type="hidden" name="redirectUrl" value="${pageContext.request.contextPath}/recipe?id=${recipe.id}">
                                    <button type="submit" class="btn btn-outline-danger btn-sm rounded-circle p-2" title="Toggle Favorite">
                                        <i class="bi ${recipe.favorite ? 'bi-heart-fill' : 'bi-heart'} fs-5"></i>
                                    </button>
                                </form>
                            </div>

                            <h1 class="fw-extrabold display-6 text-dark mb-3">${recipe.name}</h1>
                            <p class="text-muted leading-relaxed mb-4">${recipe.description}</p>

                            <!-- Key Recipe Meta Badges -->
                            <div class="row g-3 mb-4">
                                <div class="col-4">
                                    <div class="bg-light rounded-3 p-2.5 text-center">
                                        <small class="text-muted d-block text-uppercase" style="font-size: 0.7rem;">Prep Time</small>
                                        <span class="fw-bold text-dark"><i class="bi bi-clock me-1 text-primary"></i>${recipe.prepTimeMins} mins</span>
                                    </div>
                                </div>
                                <div class="col-4">
                                    <div class="bg-light rounded-3 p-2.5 text-center">
                                        <small class="text-muted d-block text-uppercase" style="font-size: 0.7rem;">Cook Time</small>
                                        <span class="fw-bold text-dark"><i class="bi bi-fire me-1 text-danger"></i>${recipe.cookTimeMins} mins</span>
                                    </div>
                                </div>
                                <div class="col-4">
                                    <div class="bg-light rounded-3 p-2.5 text-center">
                                        <small class="text-muted d-block text-uppercase" style="font-size: 0.7rem;">Servings</small>
                                        <span class="fw-bold text-dark"><i class="bi bi-people me-1 text-success"></i>${recipe.servings} Servings</span>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <!-- Action Bar -->
                        <div class="d-flex flex-wrap gap-2 pt-3 border-top">
                            <c:if test="${sessionScope.user.admin || recipe.userId == sessionScope.user.id || recipe.userId == 1}">
                                <a href="${pageContext.request.contextPath}/edit-recipe?id=${recipe.id}" class="btn btn-outline-primary btn-sm rounded-pill px-3">
                                    <i class="bi bi-pencil me-1"></i> Edit Recipe
                                </a>
                                <button type="button" class="btn btn-outline-danger btn-sm rounded-pill px-3" data-bs-toggle="modal" data-bs-target="#deleteModal">
                                    <i class="bi bi-trash me-1"></i> Delete
                                </button>
                            </c:if>
                            <a href="${pageContext.request.contextPath}/recipes" class="btn btn-light border btn-sm rounded-pill px-3">
                                <i class="bi bi-arrow-left me-1"></i> All Recipes
                            </a>
                            <a href="${pageContext.request.contextPath}/meal-planner" class="btn btn-emerald btn-sm rounded-pill px-3 ms-auto">
                                <i class="bi bi-calendar-plus me-1"></i> Add to Meal Plan
                            </a>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Nutrition Module -->
            <div class="mb-4">
                <h4 class="fw-bold mb-3"><i class="bi bi-pie-chart-fill me-2 text-warning"></i>Nutrition Information</h4>
                <div class="row g-3">
                    <div class="col-6 col-md-3">
                        <div class="nutrition-card">
                            <div class="nutrition-value text-emerald">${recipe.calories}</div>
                            <div class="nutrition-label">Calories (kcal)</div>
                        </div>
                    </div>
                    <div class="col-6 col-md-3">
                        <div class="nutrition-card">
                            <div class="nutrition-value text-primary">${recipe.proteinG} g</div>
                            <div class="nutrition-label">Protein</div>
                        </div>
                    </div>
                    <div class="col-6 col-md-3">
                        <div class="nutrition-card">
                            <div class="nutrition-value text-warning">${recipe.carbsG} g</div>
                            <div class="nutrition-label">Carbohydrates</div>
                        </div>
                    </div>
                    <div class="col-6 col-md-3">
                        <div class="nutrition-card">
                            <div class="nutrition-value text-danger">${recipe.fatG} g</div>
                            <div class="nutrition-label">Fat</div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Ingredients & Steps to Prepare Food Row -->
            <div class="row g-4">
                <!-- Ingredients Checklist -->
                <div class="col-lg-5">
                    <div class="card border-0 shadow-sm rounded-4 p-4 bg-white h-100">
                        <h4 class="fw-bold mb-3 text-dark d-flex align-items-center justify-content-between">
                            <span><i class="bi bi-basket-fill text-success me-2"></i>Ingredients</span>
                            <span class="badge bg-light text-muted border font-monospace">${ingredientItems.size()} items</span>
                        </h4>

                        <div class="ingredient-list">
                            <c:forEach var="item" items="${ingredientItems}" varStatus="loop">
                                <div class="ingredient-item">
                                    <input class="form-check-input flex-shrink-0" type="checkbox" id="ing_${loop.index}">
                                    <label class="form-check-label text-capitalize cursor-pointer" for="ing_${loop.index}">
                                        ${item}
                                    </label>
                                </div>
                            </c:forEach>
                        </div>
                    </div>
                </div>

                <!-- Steps to Prepare Food -->
                <div class="col-lg-7">
                    <div class="card border-0 shadow-sm rounded-4 p-4 bg-white h-100">
                        <h4 class="fw-bold mb-3 text-dark d-flex align-items-center justify-content-between">
                            <span><i class="bi bi-list-ol text-primary me-2"></i>Steps to Prepare Food</span>
                            <span class="badge bg-primary bg-opacity-10 text-primary rounded-pill px-3 py-1.5" style="font-size: 0.85rem;">
                                ${preparationSteps.size()} Steps &bull; ${recipe.totalTimeMins} mins total
                            </span>
                        </h4>
                        <div class="d-flex flex-column gap-3">
                            <c:forEach var="step" items="${preparationSteps}" varStatus="loop">
                                <label class="d-flex align-items-start gap-3 p-3 rounded-3 bg-light border border-transparent cursor-pointer step-card"
                                       for="step_${loop.index}">
                                    <input class="form-check-input mt-1 flex-shrink-0 step-checkbox" type="checkbox" id="step_${loop.index}"
                                           onchange="this.closest('.step-card').classList.toggle('opacity-50', this.checked)">
                                    <div class="flex-grow-1">
                                        <div class="fw-bold text-success small text-uppercase mb-1">Step ${loop.count}</div>
                                        <div class="text-dark lh-base">${step}</div>
                                    </div>
                                </label>
                            </c:forEach>
                        </div>
                    </div>
                </div>
            </div>

        </div>
    </main>
</div>

<!-- Delete Confirmation Modal -->
<div class="modal fade" id="deleteModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 rounded-4 shadow">
            <div class="modal-header border-0 pb-0">
                <h5 class="modal-title fw-bold text-danger"><i class="bi bi-exclamation-triangle-fill me-2"></i>Confirm Deletion</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <div class="modal-body text-muted">
                Are you sure you want to delete <strong>"${recipe.name}"</strong>? This action cannot be undone.
            </div>
            <div class="modal-footer border-0 pt-0">
                <button type="button" class="btn btn-light rounded-pill px-3" data-bs-dismiss="modal">Cancel</button>
                <form action="${pageContext.request.contextPath}/delete-recipe" method="POST" class="d-inline">
                    <input type="hidden" name="id" value="${recipe.id}">
                    <button type="submit" class="btn btn-danger rounded-pill px-4">Delete Recipe</button>
                </form>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
