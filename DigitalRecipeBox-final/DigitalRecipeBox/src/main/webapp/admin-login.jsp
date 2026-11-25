<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<jsp:include page="/WEB-INF/includes/header.jsp">
    <jsp:param name="title" value="Administrator Sign In" />
</jsp:include>
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<div class="container py-5">
    <div class="row justify-content-center">
        <div class="col-md-6 col-lg-5">
            <div class="card border-0 shadow-lg rounded-4 overflow-hidden">
                <div class="card-header bg-dark text-white p-4 text-center border-0">
                    <div class="brand-icon mx-auto mb-2" style="width: 48px; height: 48px; font-size: 1.5rem;">
                        <i class="bi bi-shield-lock"></i>
                    </div>
                    <h3 class="fw-bold mb-1">Administrator Sign In</h3>
                    <p class="text-white-50 small mb-0">Sign in with an administrator account</p>
                </div>
                <div class="card-body p-4">
                    <c:if test="${not empty errorMessage}">
                        <div class="alert alert-danger" role="alert">
                            <i class="bi bi-exclamation-triangle-fill me-2"></i>${errorMessage}
                        </div>
                    </c:if>
                    <form action="${pageContext.request.contextPath}/admin/login" method="POST">
                        <div class="mb-3">
                            <label class="form-label fw-semibold" for="identifier">Username or Email</label>
                            <input id="identifier" type="text" name="identifier" class="form-control"
                                   placeholder="Administrator username or email" required autofocus>
                        </div>
                        <div class="mb-4">
                            <label class="form-label fw-semibold" for="password">Password</label>
                            <input id="password" type="password" name="password" class="form-control"
                                   placeholder="Administrator password" required>
                        </div>
                        <button type="submit" class="btn btn-emerald w-100 py-2 rounded-3 fw-bold mb-3">
                            <i class="bi bi-box-arrow-in-right me-1"></i> Sign In as Administrator
                        </button>
                    </form>
                    <div class="alert alert-light border text-muted small mb-0 text-center">
                        <i class="bi bi-shield-check text-success me-1"></i> <strong>Admin Demo Credentials:</strong><br>
                        Username: <code>admin</code> | Password: <code>Admin@123</code>
                    </div>
                </div>
                <div class="card-footer bg-light p-3 text-center border-0">
                    <a href="${pageContext.request.contextPath}/login.jsp" class="text-success text-decoration-none">
                        Return to user sign in
                    </a>
                </div>
            </div>
        </div>
    </div>
</div>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
