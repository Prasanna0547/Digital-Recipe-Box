<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<jsp:include page="/WEB-INF/includes/header.jsp">
    <jsp:param name="title" value="My Favorite Recipes" />
</jsp:include>
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<div class="app-wrapper">
    <jsp:include page="/WEB-INF/includes/sidebar.jsp" />

    <main class="main-content">
        <div class="container-fluid">
            <!-- Header -->
            <div class="d-flex justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold mb-1"><i class="bi bi-heart-fill text-danger me-2"></i>My Favorites</h2>
                    <p class="text-muted mb-0">Your saved collection of favorite recipes.</p>
                </div>
            </div>

            <!-- Favorites Grid -->
            <c:choose>
                <c:when test="${not empty favoriteRecipes}">
                    <div class="row g-4">
                        <c:forEach var="recipe" items="${favoriteRecipes}">
                            <div class="col-md-6 col-lg-4">
                                <div class="recipe-card">
                                    <div class="recipe-img-wrapper">
                                        <img src="${recipe.imageUrl}" alt="${recipe.name}" class="recipe-img"
                                             onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/images/default-dish.svg';">
                                        <span class="badge-category">${recipe.categoryName}</span>

                                        <form action="${pageContext.request.contextPath}/favorite" method="POST" class="d-inline">
                                            <input type="hidden" name="recipeId" value="${recipe.id}">
                                            <input type="hidden" name="action" value="remove">
                                            <input type="hidden" name="redirectUrl" value="${pageContext.request.contextPath}/favorites">
                                            <button type="submit" class="btn-favorite active" title="Remove Favorite">
                                                <i class="bi bi-heart-fill"></i>
                                            </button>
                                        </form>
                                    </div>
                                    <div class="recipe-body">
                                        <h5 class="recipe-title">${recipe.name}</h5>
                                        <p class="recipe-desc">${recipe.description}</p>
                                        <div class="recipe-meta">
                                            <span><i class="bi bi-clock me-1"></i>${recipe.totalTimeMins} mins</span>
                                            <span><i class="bi bi-fire me-1 text-danger"></i>${recipe.calories} kcal</span>
                                            <span class="badge ${recipe.difficulty == 'Easy' ? 'badge-easy' : 'badge-medium'} px-2 py-1 rounded-pill">
                                                ${recipe.difficulty}
                                            </span>
                                        </div>
                                        <a href="${pageContext.request.contextPath}/recipe?id=${recipe.id}" class="btn btn-emerald btn-sm w-100 mt-3 rounded-3">
                                            View Details <i class="bi bi-chevron-right ms-1"></i>
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="card border-0 shadow-sm rounded-4 p-5 text-center bg-white my-4">
                        <div class="stat-icon bg-purple-light mx-auto mb-3" style="width: 70px; height: 70px; font-size: 2rem;">
                            <i class="bi bi-heart"></i>
                        </div>
                        <h4 class="fw-bold">No Favorite Recipes Saved</h4>
                        <p class="text-muted col-md-6 mx-auto">Click the heart icon on any recipe card to save it to your quick access collection.</p>
                        <div>
                            <a href="${pageContext.request.contextPath}/recipes" class="btn btn-emerald rounded-pill px-4">
                                <i class="bi bi-book me-1"></i> Browse Recipes
                            </a>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>
</div>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
