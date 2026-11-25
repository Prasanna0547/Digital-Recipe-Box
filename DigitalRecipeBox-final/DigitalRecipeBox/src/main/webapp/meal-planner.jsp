<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<jsp:include page="/WEB-INF/includes/header.jsp">
    <jsp:param name="title" value="Weekly Meal Planner" />
</jsp:include>
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<div class="app-wrapper">
    <jsp:include page="/WEB-INF/includes/sidebar.jsp" />

    <main class="main-content">
        <div class="container-fluid">
            <!-- Header -->
            <div class="d-flex flex-wrap justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold mb-1"><i class="bi bi-calendar-week-fill text-amber me-2"></i>Meal Planner</h2>
                    <p class="text-muted mb-0">Schedule your daily & weekly meals, breakfast, lunch, and dinner.</p>
                </div>
                <div class="d-flex gap-2 mt-2 mt-md-0">
                    <button type="button" class="btn btn-emerald rounded-pill px-4" data-bs-toggle="modal" data-bs-target="#addMealModal">
                        <i class="bi bi-calendar-plus me-1"></i> Plan a Meal
                    </button>
                    <form action="${pageContext.request.contextPath}/shopping-list" method="POST" class="d-inline">
                        <input type="hidden" name="action" value="generate_from_mealplan">
                        <button type="submit" class="btn btn-warning text-dark fw-bold rounded-pill px-4">
                            <i class="bi bi-cart-plus-fill me-1"></i> Generate Shopping List
                        </button>
                    </form>
                </div>
            </div>

            <!-- Planned Meals List -->
            <c:choose>
                <c:when test="${not empty mealPlans}">
                    <div class="row g-4">
                        <c:forEach var="plan" items="${mealPlans}">
                            <div class="col-md-6 col-lg-4">
                                <div class="card border-0 shadow-sm rounded-4 overflow-hidden h-100 bg-white">
                                    <div class="card-header bg-light border-0 d-flex align-items-center justify-content-between p-3">
                                        <span class="badge ${plan.mealType == 'Breakfast' ? 'bg-amber-light text-warning' : (plan.mealType == 'Lunch' ? 'bg-emerald-light text-success' : 'bg-purple-light text-purple')} px-3 py-1.5 rounded-pill fw-bold" style="font-size: 0.85rem;">
                                            <i class="bi ${plan.mealType == 'Breakfast' ? 'bi-sun-fill' : (plan.mealType == 'Lunch' ? 'bi-brightness-high-fill' : 'bi-moon-stars-fill')} me-1"></i>
                                            ${plan.mealType}
                                        </span>
                                        <span class="fw-bold text-muted small"><i class="bi bi-calendar3 me-1"></i>${plan.mealDate}</span>
                                    </div>
                                    <div class="card-body p-3 d-flex gap-3 align-items-center">
                                        <img src="${plan.recipeImageUrl}" alt="${plan.recipeName}" class="rounded-3" style="width: 80px; height: 80px; object-fit: cover;"
                                             onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/images/default-dish.svg';">
                                        <div class="flex-grow-1">
                                            <h6 class="fw-bold text-dark mb-1">${plan.recipeName}</h6>
                                            <small class="text-muted d-block"><i class="bi bi-clock me-1"></i>${plan.prepTimeMins + plan.cookTimeMins} mins total</small>
                                            <small class="text-danger fw-semibold d-block"><i class="bi bi-fire me-1"></i>${plan.calories} kcal</small>
                                        </div>
                                    </div>
                                    <div class="card-footer bg-white border-0 p-3 pt-0 d-flex justify-content-between align-items-center">
                                        <a href="${pageContext.request.contextPath}/recipe?id=${plan.recipeId}" class="btn btn-link text-success p-0 text-decoration-none fw-semibold small">
                                            View Recipe <i class="bi bi-arrow-right ms-1"></i>
                                        </a>
                                        <form action="${pageContext.request.contextPath}/meal-planner" method="POST" class="d-inline">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="planId" value="${plan.id}">
                                            <button type="submit" class="btn btn-light btn-sm text-danger rounded-circle" title="Remove Meal">
                                                <i class="bi bi-trash"></i>
                                            </button>
                                        </form>
                                    </div>
                                </div>
                            </div>
                        </c:forEach>
                    </div>
                </c:when>
                <c:otherwise>
                    <div class="card border-0 shadow-sm rounded-4 p-5 text-center bg-white my-4">
                        <div class="stat-icon bg-amber-light mx-auto mb-3" style="width: 70px; height: 70px; font-size: 2rem;">
                            <i class="bi bi-calendar-x"></i>
                        </div>
                        <h4 class="fw-bold">No Planned Meals Yet</h4>
                        <p class="text-muted col-md-6 mx-auto">Organize your weekly diet by scheduling breakfast, lunch, and dinner recipes.</p>
                        <div>
                            <button type="button" class="btn btn-emerald rounded-pill px-4" data-bs-toggle="modal" data-bs-target="#addMealModal">
                                <i class="bi bi-calendar-plus me-1"></i> Plan Your First Meal
                            </button>
                        </div>
                    </div>
                </c:otherwise>
            </c:choose>
        </div>
    </main>
</div>

<!-- Modal: Assign Meal Plan -->
<div class="modal fade" id="addMealModal" tabindex="-1">
    <div class="modal-dialog modal-dialog-centered">
        <div class="modal-content border-0 rounded-4 shadow">
            <div class="modal-header border-0 pb-0">
                <h5 class="modal-title fw-bold text-dark"><i class="bi bi-calendar-plus text-success me-2"></i>Schedule a Meal</h5>
                <button type="button" class="btn-close" data-bs-dismiss="modal"></button>
            </div>
            <form action="${pageContext.request.contextPath}/meal-planner" method="POST">
                <input type="hidden" name="action" value="add">
                <div class="modal-body p-4">
                    <div class="mb-3">
                        <label class="form-label fw-semibold">Select Date</label>
                        <input type="date" name="mealDate" class="form-control" required value="<%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>">
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Meal Type</label>
                        <select name="mealType" class="form-select" required>
                            <option value="Breakfast">Breakfast</option>
                            <option value="Lunch" selected>Lunch</option>
                            <option value="Dinner">Dinner</option>
                            <option value="Snack">Snack</option>
                        </select>
                    </div>

                    <div class="mb-3">
                        <label class="form-label fw-semibold">Choose Recipe</label>
                        <select name="recipeId" class="form-select" required>
                            <c:forEach var="recipe" items="${recipes}">
                                <option value="${recipe.id}">${recipe.name} (${recipe.categoryName})</option>
                            </c:forEach>
                        </select>
                    </div>
                </div>
                <div class="modal-footer border-0 pt-0">
                    <button type="button" class="btn btn-light rounded-pill px-3" data-bs-dismiss="modal">Cancel</button>
                    <button type="submit" class="btn btn-emerald rounded-pill px-4">Add to Planner</button>
                </div>
            </form>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
