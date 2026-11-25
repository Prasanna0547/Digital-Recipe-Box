<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<jsp:include page="/WEB-INF/includes/header.jsp">
    <jsp:param name="title" value="User Login" />
</jsp:include>
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-6 col-lg-5">
            <div class="card border-0 shadow-lg rounded-4 overflow-hidden">
                <div class="card-header bg-dark text-white p-4 text-center border-0">
                    <div class="brand-icon mx-auto mb-2" style="width: 48px; height: 48px; font-size: 1.5rem;">
                        <i class="bi bi-box-arrow-in-right"></i>
                    </div>
                    <h3 class="fw-bold mb-1">Welcome Back</h3>
                    <p class="text-white-50 small mb-0">Sign in to access your digital recipe box</p>
                </div>
                <div class="card-body p-4">

                    <!-- Alert Messages -->
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger alert-dismissible fade show" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i> ${errorMessage}
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    <c:if test="${param.error == 'login_required'}">
                        <div class="alert alert-warning alert-dismissible fade show" role="alert">
                            <i class="bi bi-shield-lock-fill me-2"></i> Please login to access protected recipe features.
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    <c:if test="${param.success == 'registered'}">
                        <div class="alert alert-success alert-dismissible fade show" role="alert">
                            <i class="bi bi-check-circle-fill me-2"></i> Account registered successfully! Please sign in below.
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>
                    <c:if test="${param.info == 'logged_out'}">
                        <div class="alert alert-info alert-dismissible fade show" role="alert">
                            <i class="bi bi-info-circle-fill me-2"></i> You have logged out successfully.
                            <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                        </div>
                    </c:if>

                    <form action="${pageContext.request.contextPath}/login" method="POST">
                        <div class="mb-3">
                            <label class="form-label fw-semibold">Username or Email</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light text-muted"><i class="bi bi-person"></i></span>
                                <input type="text" name="identifier" class="form-control" placeholder="Enter username or email" required autofocus>
                            </div>
                        </div>

                        <div class="mb-4">
                            <label class="form-label fw-semibold">Password</label>
                            <div class="input-group">
                                <span class="input-group-text bg-light text-muted"><i class="bi bi-lock"></i></span>
                                <input type="password" name="password" class="form-control" placeholder="Enter password" required>
                            </div>
                        </div>

                        <button type="submit" class="btn btn-emerald w-100 py-2.5 rounded-3 fw-bold mb-3">
                            <i class="bi bi-box-arrow-in-right me-1"></i> Sign In
                        </button>
                    </form>

                    <!-- Academic Demo Credentials Note -->
                    <div class="alert alert-light border text-muted small mb-0 text-center">
                        <i class="bi bi-key-fill text-warning me-1"></i> <strong>Demo Credentials:</strong><br>
                        Username: <code>demo</code> | Password: <code>demo123</code>
                    </div>
                </div>
                <div class="card-footer bg-light p-3 text-center border-0">
                    <span class="text-muted">Don't have an account?</span> 
                    <a href="${pageContext.request.contextPath}/register.jsp" class="fw-bold text-success text-decoration-none">Register Now</a>
                    <div class="mt-2">
                        <a href="${pageContext.request.contextPath}/admin/login" class="small text-muted text-decoration-none">
                            <i class="bi bi-shield-lock me-1"></i>Administrator sign in
                        </a>
                    </div>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
