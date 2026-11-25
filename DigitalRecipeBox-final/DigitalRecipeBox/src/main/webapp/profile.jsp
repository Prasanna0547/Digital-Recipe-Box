<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="jakarta.tags.core" prefix="c" %>

<jsp:include page="/WEB-INF/includes/header.jsp">
    <jsp:param name="title" value="My Profile & Settings" />
</jsp:include>
<jsp:include page="/WEB-INF/includes/navbar.jsp" />

<div class="app-wrapper">
    <jsp:include page="/WEB-INF/includes/sidebar.jsp" />

    <main class="main-content">
        <div class="container-fluid">
            <!-- Header -->
            <div class="mb-4">
                <h2 class="fw-bold mb-1"><i class="bi bi-person-gear text-success me-2"></i>My Profile & Account Settings</h2>
                <p class="text-muted mb-0">Manage your user details and password security.</p>
            </div>

            <div class="row g-4">
                <!-- User Summary Card -->
                <div class="col-lg-4">
                    <div class="card border-0 shadow-sm rounded-4 p-4 text-center bg-white mb-4">
                        <div class="bg-success text-white rounded-circle mx-auto d-flex align-items-center justify-content-center mb-3" 
                             style="width: 90px; height: 90px; font-size: 2.5rem; font-weight: 800;">
                            ${sessionScope.user.fullName.substring(0, 1).toUpperCase()}
                        </div>
                        <h4 class="fw-bold text-dark mb-1">${sessionScope.user.fullName}</h4>
                        <p class="text-muted small mb-2">@${sessionScope.user.username}</p>
                        <c:choose>
                            <c:when test="${sessionScope.user.admin}">
                                <span class="badge bg-danger bg-opacity-10 text-danger border border-danger border-opacity-25 px-3 py-1.5 rounded-pill mb-3">
                                    <i class="bi bi-shield-lock-fill me-1"></i> Administrator
                                </span>
                            </c:when>
                            <c:otherwise>
                                <span class="badge bg-emerald-light text-success border border-success border-opacity-25 px-3 py-1.5 rounded-pill mb-3">
                                    Registered Member
                                </span>
                            </c:otherwise>
                        </c:choose>
                        
                        <div class="text-start border-top pt-3 text-muted small">
                            <div class="mb-2"><i class="bi bi-envelope me-2 text-primary"></i>${sessionScope.user.email}</div>
                            <div><i class="bi bi-calendar-check me-2 text-warning"></i>Member Since: ${sessionScope.user.createdAt}</div>
                        </div>
                    </div>
                </div>

                <!-- Profile Edit & Password Forms -->
                <div class="col-lg-8">
                    <!-- Update Profile Form -->
                    <div class="card border-0 shadow-sm rounded-4 p-4 bg-white mb-4">
                        <h5 class="fw-bold border-bottom pb-3 mb-3 text-dark"><i class="bi bi-pencil-square me-2 text-success"></i>Update Personal Information</h5>

                        <c:if test="${not empty successMessage}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="bi bi-check-circle-fill me-2"></i> ${successMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>
                        <c:if test="${not empty errorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i> ${errorMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/profile" method="POST">
                            <input type="hidden" name="action" value="updateProfile">
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Full Name</label>
                                <input type="text" name="fullName" class="form-control" value="${sessionScope.user.fullName}" required>
                            </div>
                            <div class="mb-4">
                                <label class="form-label fw-semibold">Email Address</label>
                                <input type="email" name="email" class="form-control" value="${sessionScope.user.email}" required>
                            </div>
                            <button type="submit" class="btn btn-emerald rounded-pill px-4 fw-bold">
                                Save Profile Changes
                            </button>
                        </form>
                    </div>

                    <!-- Change Password Form -->
                    <div class="card border-0 shadow-sm rounded-4 p-4 bg-white">
                        <h5 class="fw-bold border-bottom pb-3 mb-3 text-dark"><i class="bi bi-shield-lock me-2 text-danger"></i>Change Security Password</h5>

                        <c:if test="${not empty passwordSuccessMessage}">
                            <div class="alert alert-success alert-dismissible fade show" role="alert">
                                <i class="bi bi-check-circle-fill me-2"></i> ${passwordSuccessMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>
                        <c:if test="${not empty passwordErrorMessage}">
                            <div class="alert alert-danger alert-dismissible fade show" role="alert">
                                <i class="bi bi-exclamation-triangle-fill me-2"></i> ${passwordErrorMessage}
                                <button type="button" class="btn-close" data-bs-dismiss="alert"></button>
                            </div>
                        </c:if>

                        <form action="${pageContext.request.contextPath}/profile" method="POST">
                            <input type="hidden" name="action" value="changePassword">
                            <div class="mb-3">
                                <label class="form-label fw-semibold">Current Password</label>
                                <input type="password" name="currentPassword" class="form-control" required>
                            </div>
                            <div class="mb-3">
                                <label class="form-label fw-semibold">New Password</label>
                                <input type="password" name="newPassword" class="form-control" required minlength="6">
                            </div>
                            <div class="mb-4">
                                <label class="form-label fw-semibold">Confirm New Password</label>
                                <input type="password" name="confirmPassword" class="form-control" required minlength="6">
                            </div>
                            <button type="submit" class="btn btn-outline-danger rounded-pill px-4 fw-bold">
                                Update Password
                            </button>
                        </form>
                    </div>
                </div>
            </div>

        </div>
    </main>
</div>

<jsp:include page="/WEB-INF/includes/footer.jsp" />
