<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<jsp:include page="/WEB-INF/includes/header.jsp">
    <jsp:param name="title" value="My Recipes Catalogue" />
</jsp:include>
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<div class="app-wrapper">
    <jsp:include page="/WEB-INF/includes/sidebar.jsp" />

    <main class="main-content">
        <div class="container-fluid">
            <!-- Header -->
            <div class="d-flex flex-wrap justify-content-between align-items-center mb-4 gap-2">
                <div>
                    <h2 class="fw-bold mb-1">
                        Recipes List &amp; Catalogue
                        <c:if test="${sessionScope.user.admin}">
                            <span class="badge bg-danger fs-6 align-middle ms-2">Admin View</span>
                        </c:if>
                    </h2>
                    <p class="text-muted mb-0">Browse ${recipes.size()} dish(es), filter by category or cook time, and open step-by-step cooking guides.</p>
                </div>
                <div class="d-flex align-items-center gap-2">
                    <div class="btn-group" role="group" aria-label="View mode">
                        <button type="button" id="btnGridView" class="btn btn-outline-success btn-sm active" onclick="setRecipesView('grid')">
                            <i class="bi bi-grid-3x3-gap-fill me-1"></i> Grid
                        </button>
                        <button type="button" id="btnListView" class="btn btn-outline-success btn-sm" onclick="setRecipesView('list')">
                            <i class="bi bi-list-ul me-1"></i> List
                        </button>
                    </div>
                    <a href="${pageContext.request.contextPath}/add-recipe" class="btn btn-emerald rounded-pill px-4">
                        <i class="bi bi-plus-lg me-1"></i> Add New Recipe
                    </a>
                </div>
            </div>

            <c:if test="${param.msg == 'deleted'}">
                <div class="alert alert-success alert-dismissible fade show mb-4" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i> Recipe deleted successfully.
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Filter & Search Toolbar Card -->
            <div class="card border-0 shadow-sm rounded-4 p-3 mb-4 bg-white">
                <form action="${pageContext.request.contextPath}/recipes" method="GET" class="row g-2 align-items-center">
                    <!-- Search Input -->
                    <div class="col-md-3">
                        <div class="input-group">
                            <span class="input-group-text bg-light border-end-0 text-muted"><i class="bi bi-search"></i></span>
                            <input type="text" name="search" class="form-control border-start-0 shadow-none ps-0" 
                                   placeholder="Search name or ingredients..." value="${paramSearch}">
                        </div>
                    </div>

                    <!-- Category Dropdown -->
                    <div class="col-md-2">
                        <select name="category" class="form-select shadow-none">
                            <option value="all">All Categories</option>
                            <c:forEach var="cat" items="${categories}">
                                <option value="${cat.id}" ${paramCategory == cat.id ? 'selected' : ''}>${cat.name}</option>
                            </c:forEach>
                        </select>
                    </div>

                    <!-- Difficulty Dropdown -->
                    <div class="col-md-2">
                        <select name="difficulty" class="form-select shadow-none">
                            <option value="all">Any Difficulty</option>
                            <option value="Easy" ${paramDifficulty == 'Easy' ? 'selected' : ''}>Easy</option>
                            <option value="Medium" ${paramDifficulty == 'Medium' ? 'selected' : ''}>Medium</option>
                            <option value="Hard" ${paramDifficulty == 'Hard' ? 'selected' : ''}>Hard</option>
                        </select>
                    </div>

                    <!-- Max Cook Time -->
                    <div class="col-md-2">
                        <select name="maxTime" class="form-select shadow-none">
                            <option value="">Any Time</option>
                            <option value="15" ${paramMaxTime == '15' ? 'selected' : ''}>&le; 15 mins</option>
                            <option value="30" ${paramMaxTime == '30' ? 'selected' : ''}>&le; 30 mins</option>
                            <option value="45" ${paramMaxTime == '45' ? 'selected' : ''}>&le; 45 mins</option>
                            <option value="60" ${paramMaxTime == '60' ? 'selected' : ''}>&le; 60 mins</option>
                        </select>
                    </div>

                    <!-- Sort By -->
                    <div class="col-md-2">
                        <select name="sortBy" class="form-select shadow-none">
                            <option value="newest" ${empty paramSortBy || paramSortBy == 'newest' ? 'selected' : ''}>Newest First</option>
                            <option value="name_asc" ${paramSortBy == 'name_asc' ? 'selected' : ''}>Name (A-Z)</option>
                            <option value="time_asc" ${paramSortBy == 'time_asc' ? 'selected' : ''}>Quickest First</option>
                            <option value="calories_asc" ${paramSortBy == 'calories_asc' ? 'selected' : ''}>Lowest Calories</option>
                        </select>
                    </div>

                    <!-- Submit & Reset -->
                    <div class="col-md-1 d-flex gap-1">
                        <button type="submit" class="btn btn-emerald flex-grow-1" title="Apply Filters">Go</button>
                        <a href="${pageContext.request.contextPath}/recipes" class="btn btn-light border text-muted" title="Reset Filters">
                            <i class="bi bi-arrow-counterclockwise"></i>
                        </a>
                    </div>
                </form>
            </div>

            <!-- Recipes Grid & List -->
            <c:choose>
                <c:when test="${not empty recipes}">
                    <!-- Card Grid View -->
                    <div id="recipesGridView" class="row g-4">
                        <c:forEach var="recipe" items="${recipes}">
                            <div class="col-md-6 col-lg-4">
                                <div class="recipe-card">
                                    <div class="recipe-img-wrapper">
                                        <img src="${recipe.imageUrl}" alt="${recipe.name}" class="recipe-img"
                                             onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/images/default-dish.svg';">
                                        <span class="badge-category">${recipe.categoryName}</span>

                                        <form action="${pageContext.request.contextPath}/favorite" method="POST" class="d-inline">
                                            <input type="hidden" name="recipeId" value="${recipe.id}">
                                            <input type="hidden" name="redirectUrl" value="${pageContext.request.contextPath}/recipes">
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
                                            <span><i class="bi bi-list-ol me-1 text-primary"></i>${recipe.stepCount} steps</span>
                                            <span><i class="bi bi-fire me-1 text-danger"></i>${recipe.calories} kcal</span>
                                            <span class="badge ${recipe.difficulty == 'Easy' ? 'badge-easy' : (recipe.difficulty == 'Hard' ? 'badge-hard' : 'badge-medium')} px-2 py-1 rounded-pill">
                                                ${recipe.difficulty}
                                            </span>
                                        </div>
                                        <div class="d-flex gap-2 mt-3">
                                            <a href="${pageContext.request.contextPath}/recipe?id=${recipe.id}" class="btn btn-emerald btn-sm flex-grow-1 rounded-3">
                                                View Steps &amp; Details
                                            </a>
                                            <c:if test="${sessionScope.user.admin || recipe.userId == sessionScope.user.id || recipe.userId == 1}">
                                                <a href="${pageContext.request.contextPath}/edit-recipe?id=${recipe.id}" class="btn btn-light border btn-sm text-secondary rounded-3" title="Edit">
                                                    <i class="bi bi-pencil"></i>
                                                </a>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>

                    <!-- Structured Recipes List View -->
                    <div id="recipesListView" class="card border-0 shadow-sm rounded-4 bg-white overflow-hidden d-none">
                        <div class="table-responsive">
                            <table class="table table-hover align-middle mb-0">
                                <thead class="table-light">
                                    <tr>
                                        <th class="ps-4">Dish</th>
                                        <th>Category</th>
                                        <th>Prep / Cook</th>
                                        <th>Steps</th>
                                        <th>Calories</th>
                                        <th>Difficulty</th>
                                        <th class="text-end pe-4">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="recipe" items="${recipes}">
                                        <tr>
                                            <td class="ps-4">
                                                <div class="d-flex align-items-center gap-3">
                                                    <img src="${recipe.imageUrl}" alt="${recipe.name}" class="rounded-3 flex-shrink-0"
                                                         style="width: 64px; height: 48px; object-fit: cover;"
                                                         onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/images/default-dish.svg';">
                                                    <div>
                                                        <a href="${pageContext.request.contextPath}/recipe?id=${recipe.id}" class="fw-bold text-dark text-decoration-none">
                                                            ${recipe.name}
                                                        </a>
                                                        <div class="small text-muted text-truncate" style="max-width: 280px;">${recipe.description}</div>
                                                    </div>
                                                </div>
                                            </td>
                                            <td><span class="badge bg-success bg-opacity-10 text-success rounded-pill px-2 py-1">${recipe.categoryName}</span></td>
                                            <td class="small text-muted">${recipe.prepTimeMins}m / ${recipe.cookTimeMins}m</td>
                                            <td class="small fw-semibold text-primary">${recipe.stepCount} steps</td>
                                            <td class="small text-danger fw-semibold">${recipe.calories} kcal</td>
                                            <td>
                                                <span class="badge ${recipe.difficulty == 'Easy' ? 'badge-easy' : (recipe.difficulty == 'Hard' ? 'badge-hard' : 'badge-medium')} px-2 py-1 rounded-pill">
                                                    ${recipe.difficulty}
                                                </span>
                                            </td>
                                            <td class="text-end pe-4">
                                                <div class="d-inline-flex gap-1">
                                                    <a href="${pageContext.request.contextPath}/recipe?id=${recipe.id}" class="btn btn-emerald btn-sm rounded-pill px-3">
                                                        Steps
                                                    </a>
                                                    <c:if test="${sessionScope.user.admin || recipe.userId == sessionScope.user.id || recipe.userId == 1}">
                                                        <a href="${pageContext.request.contextPath}/edit-recipe?id=${recipe.id}" class="btn btn-light border btn-sm rounded-pill" title="Edit">
                                                            <i class="bi bi-pencil"></i>
                                                        </a>
                                                    </c:if>
                                                </div>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                </tbody>
                            </table>
                        </div>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="card border-0 shadow-sm rounded-4 p-5 text-center bg-white my-4">
                        <div class="stat-icon bg-emerald-light mx-auto mb-3" style="width: 70px; height: 70px; font-size: 2rem;">
                            <i class="bi bi-search"></i>
                        </div>
                        <h4 class="fw-bold">No Recipes Found</h4>
                        <p class="text-muted col-md-6 mx-auto">We couldn't find any recipes matching your search or filter criteria. Try clearing filters or adding a new recipe.</p>
                        <div>
                            <a href="${pageContext.request.contextPath}/add-recipe" class="btn btn-emerald rounded-pill px-4">
                                <i class="bi bi-plus-lg me-1"></i> Add Recipe Now
                            </a>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>
</div>

<script>
function setRecipesView(mode) {
    const grid = document.getElementById('recipesGridView');
    const list = document.getElementById('recipesListView');
    const btnGrid = document.getElementById('btnGridView');
    const btnList = document.getElementById('btnListView');
    if (!grid || !list) return;
    if (mode === 'list') {
        grid.classList.add('d-none');
        list.classList.remove('d-none');
        btnList.classList.add('active');
        btnGrid.classList.remove('active');
    } else {
        list.classList.add('d-none');
        grid.classList.remove('d-none');
        btnGrid.classList.add('active');
        btnList.classList.remove('active');
    }
    try { localStorage.setItem('recipeBoxViewMode', mode); } catch (e) {}
}
document.addEventListener('DOMContentLoaded', function() {
    try {
        if (localStorage.getItem('recipeBoxViewMode') === 'list') {
            setRecipesView('list');
        }
    } catch (e) {}
});
</script>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
