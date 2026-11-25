<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<nav class="navbar navbar-expand-lg custom-navbar sticky-top">
    <div class="container-fluid px-4">
        <!-- Brand Logo -->
        <a class="navbar-brand d-flex align-items-center gap-2" href="${pageContext.request.contextPath}/dashboard">
            <div class="brand-icon">
                <i class="bi bi-journal-bookmark-fill fs-5"></i>
            </div>
            <span>Recipe<span class="text-success">Box</span></span>
        </a>

        <!-- Mobile Toggle Button -->
        <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarMain">
            <span class="navbar-toggler-icon"></span>
        </button>

        <!-- Collapsible Content -->
        <div class="collapse navbar-collapse" id="navbarMain">
            <!-- Global Search Form -->
            <form class="d-flex mx-auto col-lg-5 my-2 my-lg-0" action="${pageContext.request.contextPath}/recipes" method="GET">
                <div class="input-group">
                    <span class="input-group-text bg-white border-end-0 text-muted">
                        <i class="bi bi-search"></i>
                    </span>
                    <input type="text" name="search" class="form-control border-start-0 ps-0 shadow-none" 
                           placeholder="Search recipes, ingredients, or meals..." value="${param.search}">
                    <button class="btn btn-emerald px-3" type="submit">Search</button>
                </div>
            </form>

            <!-- User Menu -->
            <ul class="navbar-nav ms-auto align-items-center gap-2">
                <c:choose>
                    <c:when test="${not empty sessionScope.user}">
                        <li class="nav-item me-2">
                            <a href="${pageContext.request.contextPath}/add-recipe" class="btn btn-emerald btn-sm rounded-pill px-3">
                                <i class="bi bi-plus-lg me-1"></i> Add Recipe
                            </a>
                        </li>
                        <li class="nav-item dropdown">
                            <a class="nav-link dropdown-toggle d-flex align-items-center gap-2 text-dark font-weight-semibold" 
                               href="#" role="button" data-bs-toggle="dropdown">
                                <div class="bg-success text-white rounded-circle d-flex align-items-center justify-content-center" 
                                     style="width: 35px; height: 35px; font-weight: 700;">
                                    ${sessionScope.user.fullName.substring(0, 1).toUpperCase()}
                                </div>
                                <span class="d-none d-md-inline">${sessionScope.user.fullName}</span>
                                <c:if test="${sessionScope.user.admin}">
                                    <span class="badge bg-danger rounded-pill" style="font-size: 0.65rem;">ADMIN</span>
                                </c:if>
                            </a>
                            <ul class="dropdown-menu dropdown-menu-end shadow-sm border-0 rounded-3 mt-2">
                                <li>
                                    <div class="px-3 py-2 border-bottom">
                                        <div class="fw-bold d-flex align-items-center gap-2">
                                            ${sessionScope.user.fullName}
                                            <c:if test="${sessionScope.user.admin}">
                                                <span class="badge bg-danger" style="font-size: 0.65rem;">ADMIN</span>
                                            </c:if>
                                        </div>
                                        <small class="text-muted">@${sessionScope.user.username}</small>
                                    </div>
                                </li>
                                <li>
                                    <a class="dropdown-item py-2" href="${pageContext.request.contextPath}/profile">
                                        <i class="bi bi-person me-2 text-primary"></i> My Profile
                                    </a>
                                </li>
                                <li>
                                    <a class="dropdown-item py-2" href="${pageContext.request.contextPath}/favorites">
                                        <i class="bi bi-heart me-2 text-danger"></i> Favorites
                                    </a>
                                </li>
                                <li><hr class="dropdown-divider"></li>
                                <li>
                                    <a class="dropdown-item py-2 text-danger" href="${pageContext.request.contextPath}/logout">
                                        <i class="bi bi-box-arrow-right me-2"></i> Logout
                                    </a>
                                </li>
                            </ul>
                        </li>
                    </c:when>
                    <c:otherwise>
                        <li class="nav-item">
                            <a class="nav-link fw-semibold" href="${pageContext.request.contextPath}/login.jsp">Login</a>
                        </li>
                        <li class="nav-item">
                            <a class="nav-link fw-semibold text-danger" href="${pageContext.request.contextPath}/admin/login">
                                <i class="bi bi-shield-lock me-1"></i>Admin Login
                            </a>
                        </li>
                        <li class="nav-item">
                            <a class="btn btn-emerald btn-sm rounded-pill px-3" href="${pageContext.request.contextPath}/register.jsp">Register</a>
                        </li>
                    </c:otherwise>
                </c:choose>
            </ul>
        </div>
    </div>
</nav>
