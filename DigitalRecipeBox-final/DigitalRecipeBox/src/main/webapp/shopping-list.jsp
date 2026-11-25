<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<jsp:include page="/WEB-INF/includes/header.jsp">
    <jsp:param name="title" value="Shopping List" />
</jsp:include>
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<div class="app-wrapper">
    <jsp:include page="/WEB-INF/includes/sidebar.jsp" />

    <main class="main-content">
        <div class="container-fluid">
            <!-- Header -->
            <div class="d-flex flex-wrap justify-content-between align-items-center mb-4">
                <div>
                    <h2 class="fw-bold mb-1"><i class="bi bi-cart-check-fill text-success me-2"></i>Shopping List</h2>
                    <p class="text-muted mb-0">Ingredients collected from your scheduled meal plans and custom items.</p>
                </div>
                <div class="d-flex gap-2 mt-2 mt-md-0">
                    <form action="${pageContext.request.contextPath}/shopping-list" method="POST" class="d-inline">
                        <input type="hidden" name="action" value="generate_from_mealplan">
                        <button type="submit" class="btn btn-emerald rounded-pill px-4">
                            <i class="bi bi-arrow-repeat me-1"></i> Sync Meal Plan Ingredients
                        </button>
                    </form>
                </div>
            </div>

            <!-- Notifications -->
            <c:if test="${not empty param.generated}">
                <div class="alert alert-success alert-dismissible fade show mb-4" role="alert">
                    <i class="bi bi-check-circle-fill me-2"></i> Added <strong>${param.generated}</strong> new ingredient(s) from your planned meals to the shopping list!
                    <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                </div>
            </c:if>

            <!-- Add Custom Ingredient Bar -->
            <div class="card border-0 shadow-sm rounded-4 p-3 mb-4 bg-white">
                <form action="${pageContext.request.contextPath}/shopping-list" method="POST" class="row g-2 align-items-center">
                    <input type="hidden" name="action" value="add">
                    <div class="col-md-7">
                        <input type="text" name="ingredientName" class="form-control shadow-none" placeholder="Add custom item (e.g. 2 litres Milk, Olive Oil, Salt)..." required>
                    </div>
                    <div class="col-md-3">
                        <input type="text" name="recipeSource" class="form-control shadow-none" placeholder="Category/Source (Optional)">
                    </div>
                    <div class="col-md-2">
                        <button type="submit" class="btn btn-emerald w-100 fw-bold">
                            <i class="bi bi-plus-lg me-1"></i> Add Item
                        </button>
                    </div>
                </form>
            </div>

            <!-- Shopping List Card -->
            <div class="card border-0 shadow-sm rounded-4 bg-white overflow-hidden mb-4">
                <div class="card-header bg-white p-3 border-bottom d-flex justify-content-between align-items-center">
                    <h5 class="fw-bold mb-0 text-dark">Grocery Checklist</h5>
                    <div class="d-flex gap-2">
                        <form action="${pageContext.request.contextPath}/shopping-list" method="POST" class="d-inline">
                            <input type="hidden" name="action" value="clear_completed">
                            <button type="submit" class="btn btn-light btn-sm text-secondary border rounded-pill px-3">
                                <i class="bi bi-check-all me-1"></i> Clear Completed
                            </button>
                        </form>
                        <form action="${pageContext.request.contextPath}/shopping-list" method="POST" class="d-inline">
                            <input type="hidden" name="action" value="clear_all">
                            <button type="submit" class="btn btn-light btn-sm text-danger border rounded-pill px-3">
                                <i class="bi bi-trash me-1"></i> Clear All
                            </button>
                        </form>
                    </div>
                </div>

                <div class="card-body p-0">
                    <c:choose>
                        <c:when test="${not empty shoppingItems}">
                            <div class="list-group list-group-flush">
                                <c:forEach var="item" items="${shoppingItems}">
                                    <div class="list-group-item p-3 d-flex align-items-center justify-content-between ${item.purchased ? 'bg-light text-muted' : ''}">
                                        <div class="d-flex align-items-center gap-3">
                                            <form action="${pageContext.request.contextPath}/shopping-list" method="POST" class="d-inline">
                                                <input type="hidden" name="action" value="toggle">
                                                <input type="hidden" name="itemId" value="${item.id}">
                                                <input type="hidden" name="purchased" value="${!item.purchased}">
                                                <input class="form-check-input shopping-item-checkbox fs-5 cursor-pointer" type="checkbox" ${item.purchased ? 'checked' : ''}>
                                            </form>

                                            <div>
                                                <span class="fw-bold ${item.purchased ? 'text-decoration-line-through text-muted' : 'text-dark'} fs-6">
                                                    ${item.ingredientName}
                                                </span>
                                                <c:if test="${not empty item.recipeSource}">
                                                    <span class="badge bg-light text-secondary border ms-2 small">
                                                        <i class="bi bi-journal-bookmark me-1"></i>${item.recipeSource}
                                                    </span>
                                                </c:if>
                                            </div>
                                        </div>

                                        <form action="${pageContext.request.contextPath}/shopping-list" method="POST" class="d-inline">
                                            <input type="hidden" name="action" value="delete">
                                            <input type="hidden" name="itemId" value="${item.id}">
                                            <button type="submit" class="btn btn-link text-muted p-0" title="Delete">
                                                <i class="bi bi-x-circle fs-5"></i>
                                            </button>
                                        </form>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:when>
                        <c:otherwise>
                            <div class="p-5 text-center">
                                <div class="stat-icon bg-emerald-light mx-auto mb-3" style="width: 70px; height: 70px; font-size: 2rem;">
                                    <i class="bi bi-cart3"></i>
                                </div>
                                <h4 class="fw-bold">Your Shopping List is Empty</h4>
                                <p class="text-muted col-md-6 mx-auto">Add custom items above or click <strong>"Sync Meal Plan Ingredients"</strong> to automatically generate items from scheduled meals.</p>
                            </div>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>

        </div>
    </main>
</div>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
