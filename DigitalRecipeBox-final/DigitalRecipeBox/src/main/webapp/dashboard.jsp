<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<jsp:include page="/WEB-INF/includes/header.jsp">
    <jsp:param name="title" value="Dashboard" />
</jsp:include>
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<div class="app-wrapper">
    <jsp:include page="/WEB-INF/includes/sidebar.jsp" />

    <main class="main-content">
        <div class="container-fluid">
            <!-- Welcome Header -->
            <div class="d-flex flex-wrap justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold mb-1">
                        Welcome back, ${sessionScope.user.fullName}! 👋
                        <c:if test="${sessionScope.user.admin}">
                            <span class="badge bg-danger fs-6 align-middle ms-2">Admin</span>
                        </c:if>
                    </h2>
                    <p class="text-muted mb-0">
                        <c:choose>
                            <c:when test="${sessionScope.user.admin}">
                                Administrator control view — managing the complete recipe catalogue across all users.
                            </c:when>
                            <c:otherwise>
                                Here's what's cooking in your recipe box today.
                            </c:otherwise>
                        </c:choose>
                    </p>
                </div>
                <div class="d-flex gap-2 mt-3 mt-md-0">
                    <a href="${pageContext.request.contextPath}/add-recipe" class="btn btn-emerald rounded-pill px-3">
                        <i class="bi bi-plus-lg me-1"></i> Add Recipe
                    </a>
                    <a href="${pageContext.request.contextPath}/recommendations" class="btn btn-outline-success rounded-pill px-3">
                        <i class="bi bi-magic me-1"></i> Smart Match
                    </a>
                </div>
            </div>

            <!-- Stats Overview Row -->
            <div class="row g-3 mb-4">
                <div class="col-6 col-lg-3">
                    <div class="stat-card">
                        <div class="d-flex align-items-center justify-content-between">
                            <div>
                                <span class="text-muted small fw-semibold text-uppercase">Total Recipes</span>
                                <h2 class="fw-extrabold mb-0 mt-1">${totalRecipes}</h2>
                            </div>
                            <div class="stat-icon bg-emerald-light">
                                <i class="bi bi-book"></i>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-lg-3">
                    <div class="stat-card">
                        <div class="d-flex align-items-center justify-content-between">
                            <div>
                                <span class="text-muted small fw-semibold text-uppercase">Meal Plans</span>
                                <h2 class="fw-extrabold mb-0 mt-1">${totalMealPlans}</h2>
                            </div>
                            <div class="stat-icon bg-amber-light">
                                <i class="bi bi-calendar-event"></i>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-lg-3">
                    <div class="stat-card">
                        <div class="d-flex align-items-center justify-content-between">
                            <div>
                                <span class="text-muted small fw-semibold text-uppercase">Shopping Items</span>
                                <h2 class="fw-extrabold mb-0 mt-1">${pendingShoppingItems}</h2>
                            </div>
                            <div class="stat-icon bg-orange-light">
                                <i class="bi bi-cart3"></i>
                            </div>
                        </div>
                    </div>
                </div>
                <div class="col-6 col-lg-3">
                    <div class="stat-card">
                        <div class="d-flex align-items-center justify-content-between">
                            <div>
                                <span class="text-muted small fw-semibold text-uppercase">Favorites</span>
                                <h2 class="fw-extrabold mb-0 mt-1">${totalFavorites}</h2>
                            </div>
                            <div class="stat-icon bg-purple-light">
                                <i class="bi bi-heart-fill text-danger"></i>
                            </div>
                        </div>
                    </div>
                </div>
            </div>

            <!-- Quick Action Bar -->
            <div class="card border-0 shadow-sm rounded-4 mb-4 bg-white p-3">
                <div class="d-flex flex-wrap align-items-center justify-content-between gap-3">
                    <div class="fw-bold text-dark d-flex align-items-center gap-2">
                        <i class="bi bi-lightning-charge-fill text-warning fs-5"></i> Quick Actions:
                    </div>
                    <div class="d-flex flex-wrap gap-2">
                        <a href="${pageContext.request.contextPath}/add-recipe" class="btn btn-light btn-sm border rounded-pill px-3">
                            <i class="bi bi-plus-circle text-success me-1"></i> New Recipe
                        </a>
                        <a href="${pageContext.request.contextPath}/meal-planner" class="btn btn-light btn-sm border rounded-pill px-3">
                            <i class="bi bi-calendar-plus text-primary me-1"></i> Plan Meal
                        </a>
                        <form action="${pageContext.request.contextPath}/shopping-list" method="POST" class="d-inline">
                            <input type="hidden" name="action" value="generate_from_mealplan">
                            <button type="submit" class="btn btn-light btn-sm border rounded-pill px-3">
                                <i class="bi bi-cart-plus text-warning me-1"></i> Generate Shopping List
                            </button>
                        </form>
                        <a href="${pageContext.request.contextPath}/recommendations" class="btn btn-light btn-sm border rounded-pill px-3">
                            <i class="bi bi-magic text-purple me-1"></i> Find Recipes by Ingredients
                        </a>
                    </div>
                </div>
            </div>

            <!-- Recently Added Recipes Section -->
            <div class="mb-4">
                <div class="d-flex justify-content-between align-items-center mb-3">
                    <h4 class="fw-bold mb-0"><i class="bi bi-clock-history me-2 text-success"></i>Recently Added Recipes</h4>
                    <a href="${pageContext.request.contextPath}/recipes" class="text-success fw-semibold text-decoration-none small">
                        View All (${totalRecipes}) <i class="bi bi-arrow-right"></i>
                    </a>
                </div>

                <div class="row g-4">
                    <c:forEach var="recipe" items="${recentRecipes}">
                        <div class="col-md-6 col-lg-4">
                            <div class="recipe-card">
                                <div class="recipe-img-wrapper">
                                    <img src="${recipe.imageUrl}" alt="${recipe.name}" class="recipe-img"
                                         onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/images/default-dish.svg';">
                                    <span class="badge-category">${recipe.categoryName}</span>
                                    
                                    <form action="${pageContext.request.contextPath}/favorite" method="POST" class="d-inline">
                                        <input type="hidden" name="recipeId" value="${recipe.id}">
                                        <input type="hidden" name="redirectUrl" value="${pageContext.request.contextPath}/dashboard">
                                        <button type="submit" class="btn-favorite ${recipe.favorite ? 'active' : ''}" title="Favorite">
                                            <i class="bi ${recipe.favorite ? 'bi-heart-fill' : 'bi-heart'}"></i>
                                        </button>
                                    </form>
                                </div>
                                <div class="recipe-body">
                                    <h5 class="recipe-title">${recipe.name}</h5>
                                    <p class="recipe-desc">${recipe.description}</p>
                                    <div class="recipe-meta">
                                        <span><i class="bi bi-clock me-1"></i>${recipe.totalTimeMins} mins</span>
                                        <span><i class="bi bi-fire me-1 text-danger"></i>${recipe.calories} kcal</span>
                                        <span class="badge ${recipe.difficulty == 'Easy' ? 'badge-easy' : (recipe.difficulty == 'Hard' ? 'badge-hard' : 'badge-medium')} px-2 py-1 rounded-pill">
                                            ${recipe.difficulty}
                                        </span>
                                    </div>
                                    <a href="${pageContext.request.contextPath}/recipe?id=${recipe.id}" class="btn btn-outline-success btn-sm w-100 mt-3 rounded-3">
                                        View Details <i class="bi bi-chevron-right ms-1"></i>
                                    </a>
                                </div>
                            </div>
                        </div>
                    </c:forEach>
                </div>
            </div>

            <!-- Recipe Categories Bar -->
            <div class="mb-4">
                <h4 class="fw-bold mb-3"><i class="bi bi-tags-fill me-2 text-warning"></i>Explore Categories</h4>
                <div class="row g-3">
                    <c:forEach var="cat" items="${categories}">
                        <div class="col-6 col-sm-4 col-md-3 col-lg-3">
                            <a href="${pageContext.request.contextPath}/recipes?category=${cat.id}" class="text-decoration-none">
                                <div class="card border-0 shadow-sm rounded-3 p-3 text-center h-100 hover-lift bg-white">
                                    <div class="fw-bold text-dark mb-1">${cat.name}</div>
                                    <small class="text-muted">${cat.description}</small>
                                </div>
                            </a>
                        </div>
                    </c:forEach>
                </div>
            </div>

        </div>
    </main>
</div>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
