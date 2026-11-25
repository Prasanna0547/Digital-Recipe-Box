<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" isErrorPage="true" %>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<jsp:include page="/WEB-INF/includes/header.jsp">
    <jsp:param name="title" value="An Error Occurred" />
</jsp:include>
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-8 col-lg-6">
            <div class="card border-0 shadow-lg rounded-4 p-5 text-center bg-white">
                <div class="stat-icon bg-danger bg-opacity-10 text-danger mx-auto mb-4" style="width: 80px; height: 80px; font-size: 2.5rem; border-radius: 50%;">
                    <i class="bi bi-exclamation-triangle-fill"></i>
                </div>
                <h2 class="fw-bold text-dark mb-2">Oops! Something went wrong.</h2>
                <p class="text-muted mb-4">
                    <c:choose>
                        <c:when test="${not empty errorMessage}">
                            ${errorMessage}
                        </c:when>
                        <c:otherwise>
                            We encountered an unexpected request issue or missing resource. Please return to the dashboard.
                        </c:otherwise>
                    </c:choose>
                </p>

                <div>
                    <a href="${pageContext.request.contextPath}/dashboard" class="btn btn-emerald btn-lg rounded-pill px-4 me-2">
                        <i class="bi bi-house-door-fill me-1"></i> Return to Dashboard
                    </a>
                    <a href="${pageContext.request.contextPath}/recipes" class="btn btn-outline-secondary btn-lg rounded-pill px-4">
                        Browse Recipes
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
