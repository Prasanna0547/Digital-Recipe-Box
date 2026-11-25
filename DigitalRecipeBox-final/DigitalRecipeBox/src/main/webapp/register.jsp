<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<jsp:include page="/WEB-INF/includes/header.jsp">
    <jsp:param name="title" value="Create Account" />
</jsp:include>
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-6 col-lg-5">
            <div class="card border-0 shadow-lg rounded-4 overflow-hidden">
                <div class="card-header bg-success text-white p-4 text-center border-0" style="background: linear-gradient(135deg, #10b981, #059669) !important;">
                    <div class="brand-icon mx-auto mb-2 bg-white text-success" style="width: 48px; height: 48px; font-size: 1.5rem;">
                        <i class="bi bi-person-plus-fill"></i>
                    </div>
                    <h3 class="fw-bold mb-1">Create Account</h3>
                    <p class="text-white-50 small mb-0">Join Digital Recipe Box to store & plan meals</p>
                </div>
                <div class="card-body p-4">

                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i> ${errorMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/register" method="POST">
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Full Name</label>
                            <input type="text" name="fullName" class="form-control" placeholder="e.g. Sanjay Kumar" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold">Username</label>
                            <input type="text" name="username" class="form-control" placeholder="Choose unique username" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold">Email Address</label>
                            <input type="email" name="email" class="form-control" placeholder="name@example.com" required>
                        </div>

                        <div class="mb-3">
                            <label class="form-label fw-semibold">Password</label>
                            <input type="password" name="password" class="form-control" placeholder="Minimum 6 characters" required>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-semibold">Confirm Password</label>
                            <input type="password" name="confirmPassword" class="form-control" placeholder="Re-enter password" required>
                        </div>

                        <button type="submit" class="btn btn-emerald w-100 py-2.5 rounded-3 fw-bold mb-3">
                            <i class="bi bi-person-check-fill me-1"></i> Register Account
                        </button>
                    </form>
                </div>
                <div class="card-footer bg-light p-3 text-center border-0">
                    <span class="text-muted">Already have an account?</span> 
                    <a href="${pageContext.request.contextPath}/login.jsp" class="fw-bold text-success text-decoration-none">Sign In</a>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
