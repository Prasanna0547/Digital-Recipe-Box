<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<jsp:include page="/WEB-INF/includes/header.jsp">
    <jsp:param name="title" value="Smart Recipe Recommendations" />
</jsp:include>
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<div class="app-wrapper">
    <jsp:include page="/WEB-INF/includes/sidebar.jsp" />

    <main class="main-content">
        <div class="container-fluid">
            <!-- Header -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold mb-1"><i class="bi bi-magic text-purple me-2"></i>Smart Recipe Recommendations</h2>
                    <p class="text-muted mb-0">Find recipes based on the ingredients you already have in your kitchen!</p>
                </div>
            </div>

            <!-- Ingredient Search Card -->
            <div class="card border-0 shadow-sm rounded-4 p-4 mb-4 bg-white">
                <form action="${pageContext.request.contextPath}/recommendations" method="POST">
                    <label class="form-label fw-bold text-dark fs-5 mb-2">What ingredients do you have today?</label>
                    <p class="text-muted small mb-3">Enter available ingredients separated by commas or click popular pantry tags below.</p>
                    
                    <div class="input-group input-group-lg mb-3">
                        <span class="input-group-text bg-light text-muted border-end-0"><i class="bi bi-basket2-fill"></i></span>
                        <input type="text" id="ingredientsInput" name="ingredients" class="form-control border-start-0 shadow-none" 
                               placeholder="e.g. rice, tomato, onion, egg, chicken, paneer..." value="${inputIngredients}" required>
                        <button type="submit" class="btn btn-emerald px-4 fw-bold">
                            <i class="bi bi-search me-1"></i> Match Recipes
                        </button>
                    </div>

                    <!-- Quick Pantry Tag Suggestions -->
                    <div class="d-flex flex-wrap align-items-center gap-2">
                        <span class="small fw-semibold text-muted">Quick Add Tags:</span>
                        <button type="button" class="btn btn-light btn-sm border rounded-pill ingredient-tag-btn" data-tag="rice">+ rice</button>
                        <button type="button" class="btn btn-light btn-sm border rounded-pill ingredient-tag-btn" data-tag="tomato">+ tomato</button>
                        <button type="button" class="btn btn-light btn-sm border rounded-pill ingredient-tag-btn" data-tag="onion">+ onion</button>
                        <button type="button" class="btn btn-light btn-sm border rounded-pill ingredient-tag-btn" data-tag="egg">+ egg</button>
                        <button type="button" class="btn btn-light btn-sm border rounded-pill ingredient-tag-btn" data-tag="chicken">+ chicken</button>
                        <button type="button" class="btn btn-light btn-sm border rounded-pill ingredient-tag-btn" data-tag="paneer">+ paneer</button>
                        <button type="button" class="btn btn-light btn-sm border rounded-pill ingredient-tag-btn" data-tag="garlic">+ garlic</button>
                    </div>
                </form>
            </div>

            <!-- Recommendation Results Grid -->
            <c:if test="${not empty recommendations}">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h4 class="fw-bold mb-0">Recommended Recipes (Sorted by Highest Match)</h4>
                    <span class="badge bg-success bg-opacity-10 text-success fw-bold px-3 py-2 rounded-pill">
                        ${recommendations.size()} Match(es) Found
                    </span>
                </div>

                <div class="row g-4">
                    <c:forEach var="rec" items="${recommendations}">
                        <div class="col-md-6 col-lg-6">
                            <div class="recipe-card p-0">
                                <div class="row g-0">
                                    <div class="col-md-5 recipe-img-wrapper" style="height: auto; min-height: 220px;">
                                        <img src="${rec.recipe.imageUrl}" alt="${rec.recipe.name}" class="recipe-img h-100"
                                             onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/images/default-dish.svg';">
                                        <span class="badge-category">${rec.recipe.categoryName}</span>
                                    </div>
                                    <div class="col-md-7 recipe-body p-3">
                                        <div class="d-flex justify-content-between align-items-start mb-2">
                                            <h5 class="recipe-title mb-0">${rec.recipe.name}</h5>
                                            <div class="match-badge px-2.5 py-1" style="font-size: 0.9rem;">
                                                <i class="bi bi-lightning-charge-fill text-warning"></i> ${rec.matchPercentage}% Match
                                            </div>
                                        </div>

                                        <p class="recipe-desc small mb-2">${rec.recipe.description}</p>

                                        <!-- Available & Missing Ingredients Breakdown -->
                                        <div class="mb-3">
                                            <div class="small fw-bold text-success mb-1">
                                                <i class="bi bi-check-circle-fill me-1"></i> Available Ingredients (${rec.availableIngredients.size()}):
                                            </div>
                                            <div class="d-flex flex-wrap gap-1 mb-2">
                                                <c:forEach var="av" items="${rec.availableIngredients}">
                                                    <span class="badge bg-success bg-opacity-10 text-success border border-success border-opacity-25 small">${av}</span>
                                                </c:forEach>
                                            </div>

                                            <c:if test="${not empty rec.missingIngredients}">
                                                <div class="small fw-bold text-danger mb-1">
                                                    <i class="bi bi-x-circle-fill me-1"></i> Missing Ingredients (${rec.missingIngredients.size()}):
                                                </div>
                                                <div class="d-flex flex-wrap gap-1">
                                                    <c:forEach var="ms" items="${rec.missingIngredients}">
                                                        <span class="badge bg-danger bg-opacity-10 text-danger border border-danger border-opacity-25 small">${ms}</span>
                                                    </c:forEach>
                                                </div>
                                            </c:if>
                                        </div>

                                        <div class="recipe-meta mt-auto pt-2">
                                            <span><i class="bi bi-clock me-1"></i>${rec.recipe.totalTimeMins} mins</span>
                                            <span class="badge ${rec.recipe.difficulty == 'Easy' ? 'badge-easy' : 'badge-medium'} px-2 py-1 rounded-pill">
                                                ${rec.recipe.difficulty}
                                            </span>
                                            <a href="${pageContext.request.contextPath}/recipe?id=${rec.recipe.id}" class="btn btn-emerald btn-sm rounded-pill px-3">
                                                Cook Now <i class="bi bi-arrow-right ms-1"></i>
                                            </a>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </c:if>

            <c:if test="${empty recommendations && not empty inputIngredients}">
                <div class="card border-0 shadow-sm rounded-4 p-5 text-center bg-white my-4">
                    <div class="stat-icon bg-purple-light mx-auto mb-3" style="width: 70px; height: 70px; font-size: 2rem;">
                        <i class="bi bi-emoji-frown"></i>
                    </div>
                    <h4 class="fw-bold">No Matching Recipes Found</h4>
                    <p class="text-muted col-md-6 mx-auto">We couldn't match your ingredients <strong>"${inputIngredients}"</strong> to any existing recipe. Try adding more general ingredients or add a new custom recipe!</p>
                </div>
            </c:if>

        </div>
    </main>
</div>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
