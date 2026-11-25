<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<aside class="sidebar d-none d-md-flex">
    <div class="small text-uppercase text-muted fw-bold px-3 mb-2" style="font-size: 0.75rem; letter-spacing: 1px;">
        Navigation
    </div>
    
    <a href="${pageContext.request.contextPath}/dashboard" 
       class="nav-link ${pageContext.request.requestURI.endsWith('dashboard.jsp') || pageContext.request.requestURI.endsWith('/dashboard') ? 'active' : ''}">
        <i class="bi bi-grid-fill"></i> Dashboard
    </a>

    <a href="${pageContext.request.contextPath}/recipes" 
       class="nav-link ${pageContext.request.requestURI.endsWith('recipes.jsp') || pageContext.request.requestURI.endsWith('/recipes') ? 'active' : ''}">
        <i class="bi bi-book-half"></i> All Recipes
    </a>

    <a href="${pageContext.request.contextPath}/add-recipe" 
       class="nav-link ${pageContext.request.requestURI.endsWith('add-recipe.jsp') || pageContext.request.requestURI.endsWith('/add-recipe') ? 'active' : ''}">
        <i class="bi bi-plus-circle-fill"></i> Add Recipe
    </a>

    <div class="small text-uppercase text-muted fw-bold px-3 mt-4 mb-2" style="font-size: 0.75rem; letter-spacing: 1px;">
        Meal Tools
    </div>

    <a href="${pageContext.request.contextPath}/meal-planner" 
       class="nav-link ${pageContext.request.requestURI.endsWith('meal-planner.jsp') || pageContext.request.requestURI.endsWith('/meal-planner') ? 'active' : ''}">
        <i class="bi bi-calendar-week-fill"></i> Meal Planner
    </a>

    <a href="${pageContext.request.contextPath}/shopping-list" 
       class="nav-link ${pageContext.request.requestURI.endsWith('shopping-list.jsp') || pageContext.request.requestURI.endsWith('/shopping-list') ? 'active' : ''}">
        <i class="bi bi-cart-check-fill"></i> Shopping List
    </a>

    <a href="${pageContext.request.contextPath}/recommendations" 
       class="nav-link ${pageContext.request.requestURI.endsWith('recommendations.jsp') || pageContext.request.requestURI.endsWith('/recommendations') ? 'active' : ''}">
        <i class="bi bi-magic"></i> Smart AI Match
    </a>

    <a href="${pageContext.request.contextPath}/favorites" 
       class="nav-link ${pageContext.request.requestURI.endsWith('favorites.jsp') || pageContext.request.requestURI.endsWith('/favorites') ? 'active' : ''}">
        <i class="bi bi-heart-fill"></i> Favorites
    </a>

    <div class="mt-auto pt-4 border-top">
        <c:if test="${sessionScope.user.admin}">
            <div class="px-3 mb-2">
                <span class="badge bg-danger bg-opacity-10 text-danger border border-danger border-opacity-25 w-100 py-2">
                    <i class="bi bi-shield-lock-fill me-1"></i> Administrator Mode
                </span>
            </div>
        </c:if>
        <a href="${pageContext.request.contextPath}/profile" 
           class="nav-link ${pageContext.request.requestURI.endsWith('profile.jsp') || pageContext.request.requestURI.endsWith('/profile') ? 'active' : ''}">
            <i class="bi bi-gear-fill"></i> Settings & Profile
        </a>
    </div>
</aside>
