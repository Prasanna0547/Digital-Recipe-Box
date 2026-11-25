<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<jsp:include page="/WEB-INF/includes/header.jsp">
    <jsp:param name="title" value="Welcome to Digital Recipe Box" />
</jsp:include>
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<div class="container py-5">
    <!-- Hero Banner -->
    <div class="hero-banner shadow-lg text-center text-lg-start">
        <div class="row align-items-center">
            <div class="col-lg-7">
                <span class="badge bg-success bg-opacity-25 text-success border border-success border-opacity-50 px-3 py-2 rounded-pill mb-3 fw-bold">
                    <i class="bi bi-mortarboard-fill me-1"></i> Advanced Java Mini Project
                </span>
                <h1 class="display-4 fw-extrabold mb-3">Store, Plan & Discover <br><span class="text-success">Recipes Digitally</span></h1>
                <p class="lead text-light text-opacity-75 mb-4">
                    Your modern culinary hub. Organize custom recipes, plan weekly meals, generate smart shopping lists, track nutrition, and discover dishes based on ingredients you already have!
                </p>
                <div class="d-flex flex-wrap justify-content-center justify-content-lg-start gap-3">
                    <c:choose>
                        <c:when test="${not empty sessionScope.user}">
                            <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-emerald btn-lg rounded-pill px-4">
                                <i class="bi bi-speedometer2 me-2"></i> Open Dashboard
                            </a>
                        </c:when>
                        <c:otherwise>
                            <a href="${pageContext.request.contextPath}/register.jsp" class="btn btn-emerald btn-lg rounded-pill px-4">
                                Get Started Free <i class="bi bi-arrow-right ms-2"></i>
                            </a>
                            <a href="${pageContext.request.contextPath}/login.jsp" class="btn btn-outline-light btn-lg rounded-pill px-4">
                                User Sign In
                            </a>
                            <a href="${pageContext.request.contextPath}/admin/login" class="btn btn-outline-warning btn-lg rounded-pill px-4">
                                <i class="bi bi-shield-lock me-1"></i> Admin Login
                            </a>
                        </c:otherwise>
                    </c:choose>
                </div>
            </div>
            <div class="col-lg-5 mt-4 mt-lg-0 text-center">
                <img src="${pageContext.request.contextPath}/images/dishes/hyderabadi-chicken-biryani.jpg"
                     alt="Recipe Cooking" class="img-fluid rounded-4 shadow-lg border border-secondary border-opacity-25 w-100" style="max-height: 350px; object-fit: cover;"
                     onerror="this.onerror=null;this.src='${pageContext.request.contextPath}/images/default-dish.svg';">
            </div>
        </div>
    </div>

    <!-- Popular Dishes Showcase -->
    <div class="py-4 mb-2">
        <div class="d-flex justify-content-between align-items-center mb-3">
            <h3 class="fw-bold mb-0"><i class="bi bi-stars text-warning me-2"></i>Featured Dishes &amp; Preparation Guides</h3>
            <a href="${pageContext.request.contextPath}/recipes" class="btn btn-outline-success btn-sm rounded-pill px-3">
                Explore All 20+ Recipes <i class="bi bi-arrow-right ms-1"></i>
            </a>
        </div>
        <div class="row g-3">
            <div class="col-6 col-md-4 col-lg-2">
                <div class="card border-0 shadow-sm rounded-4 overflow-hidden h-100">
                    <img src="${pageContext.request.contextPath}/images/dishes/classic-butter-chicken.jpg" alt="Classic Butter Chicken" class="w-100" style="height: 120px; object-fit: cover;">
                    <div class="p-2 text-center">
                        <div class="fw-bold small text-dark">Butter Chicken</div>
                        <small class="text-muted">Non-Veg &bull; 5 steps</small>
                    </div>
                </div>
            </div>
            <div class="col-6 col-md-4 col-lg-2">
                <div class="card border-0 shadow-sm rounded-4 overflow-hidden h-100">
                    <img src="${pageContext.request.contextPath}/images/dishes/paneer-butter-masala.jpg" alt="Paneer Butter Masala" class="w-100" style="height: 120px; object-fit: cover;">
                    <div class="p-2 text-center">
                        <div class="fw-bold small text-dark">Paneer Masala</div>
                        <small class="text-muted">Vegetarian &bull; 5 steps</small>
                    </div>
                </div>
            </div>
            <div class="col-6 col-md-4 col-lg-2">
                <div class="card border-0 shadow-sm rounded-4 overflow-hidden h-100">
                    <img src="${pageContext.request.contextPath}/images/dishes/margherita-pizza.jpg" alt="Margherita Pizza" class="w-100" style="height: 120px; object-fit: cover;">
                    <div class="p-2 text-center">
                        <div class="fw-bold small text-dark">Margherita Pizza</div>
                        <small class="text-muted">Dinner &bull; 5 steps</small>
                    </div>
                </div>
            </div>
            <div class="col-6 col-md-4 col-lg-2">
                <div class="card border-0 shadow-sm rounded-4 overflow-hidden h-100">
                    <img src="${pageContext.request.contextPath}/images/dishes/crispy-masala-dosa.jpg" alt="Crispy Masala Dosa" class="w-100" style="height: 120px; object-fit: cover;">
                    <div class="p-2 text-center">
                        <div class="fw-bold small text-dark">Masala Dosa</div>
                        <small class="text-muted">Breakfast &bull; 5 steps</small>
                    </div>
                </div>
            </div>
            <div class="col-6 col-md-4 col-lg-2">
                <div class="card border-0 shadow-sm rounded-4 overflow-hidden h-100">
                    <img src="${pageContext.request.contextPath}/images/dishes/greek-quinoa-bowl.jpg" alt="Greek Quinoa Power Bowl" class="w-100" style="height: 120px; object-fit: cover;">
                    <div class="p-2 text-center">
                        <div class="fw-bold small text-dark">Quinoa Bowl</div>
                        <small class="text-muted">Healthy &bull; 5 steps</small>
                    </div>
                </div>
            </div>
            <div class="col-6 col-md-4 col-lg-2">
                <div class="card border-0 shadow-sm rounded-4 overflow-hidden h-100">
                    <img src="${pageContext.request.contextPath}/images/dishes/warm-gulab-jamun.jpg" alt="Warm Gulab Jamun" class="w-100" style="height: 120px; object-fit: cover;">
                    <div class="p-2 text-center">
                        <div class="fw-bold small text-dark">Gulab Jamun</div>
                        <small class="text-muted">Desserts &bull; 5 steps</small>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Feature Highlights -->
    <div class="row g-4 py-4">
        <div class="col-md-4">
            <div class="stat-card h-100">
                <div class="stat-icon bg-emerald-light mb-3">
                    <i class="bi bi-magic"></i>
                </div>
                <h4 class="fw-bold">Smart Ingredient Matcher</h4>
                <p class="text-muted">Enter available ingredients in your pantry and let our algorithm suggest matching recipes instant percentage match.</p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-card h-100">
                <div class="stat-icon bg-amber-light mb-3">
                    <i class="bi bi-calendar-check"></i>
                </div>
                <h4 class="fw-bold">Meal Planner & Shopping</h4>
                <p class="text-muted">Schedule weekly breakfast, lunch, and dinner. Automatically collect ingredients directly into your interactive shopping list.</p>
            </div>
        </div>
        <div class="col-md-4">
            <div class="stat-card h-100">
                <div class="stat-icon bg-purple-light mb-3">
                    <i class="bi bi-pie-chart-fill"></i>
                </div>
                <h4 class="fw-bold">Nutritional Breakdown</h4>
                <p class="text-muted">Track calories, protein, carbohydrates, and fats for every recipe using modern nutrition cards.</p>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
