package com.digitalrecipebox.filter;

import com.digitalrecipebox.model.User;
import jakarta.servlet.Filter;
import jakarta.servlet.FilterChain;
import jakarta.servlet.FilterConfig;
import jakarta.servlet.ServletException;
import jakarta.servlet.ServletRequest;
import jakarta.servlet.ServletResponse;
import jakarta.servlet.annotation.WebFilter;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.util.Arrays;
import java.util.List;

/**
 * Authentication & Security Filter
 * Validates active user session before allowing access to protected application modules.
 */
@WebFilter("/*")
public class AuthFilter implements Filter {

    private static final List<String> PUBLIC_PATHS = Arrays.asList(
            "/",
            "/index.jsp",
            "/login",
            "/login.jsp",
            "/admin/login",
            "/admin-login.jsp",
            "/register",
            "/register.jsp",
            "/error.jsp"
    );

    @Override
    public void init(FilterConfig filterConfig) throws ServletException {
        // Initialization if needed
    }

    @Override
    public void doFilter(ServletRequest request, ServletResponse response, FilterChain chain)
            throws IOException, ServletException {

        HttpServletRequest httpRequest = (HttpServletRequest) request;
        HttpServletResponse httpResponse = (HttpServletResponse) response;

        String path = httpRequest.getRequestURI().substring(httpRequest.getContextPath().length());

        // Allow static resources (CSS, JS, images, webfonts)
        if (isStaticResource(path) || isPublicPath(path)) {
            chain.doFilter(request, response);
            return;
        }

        // Check authentication
        HttpSession session = httpRequest.getSession(false);
        boolean isLoggedIn = (session != null && session.getAttribute("user") != null);

        if (isLoggedIn) {
            chain.doFilter(request, response);
        } else {
            // Unauthenticated user attempting to access protected page
            httpResponse.sendRedirect(httpRequest.getContextPath() + "/login.jsp?error=login_required");
        }
    }

    private boolean isPublicPath(String path) {
        if (PUBLIC_PATHS.contains(path)) {
            return true;
        }
        // Handle parameters or query strings
        for (String publicPath : PUBLIC_PATHS) {
            if (path.startsWith(publicPath) && !publicPath.equals("/")) {
                return true;
            }
        }
        return false;
    }

    private boolean isStaticResource(String path) {
        return path.startsWith("/css/") ||
               path.startsWith("/js/") ||
               path.startsWith("/images/") ||
               path.endsWith(".css") ||
               path.endsWith(".js") ||
               path.endsWith(".png") ||
               path.endsWith(".jpg") ||
               path.endsWith(".jpeg") ||
               path.endsWith(".gif") ||
               path.endsWith(".ico") ||
               path.endsWith(".svg") ||
               path.endsWith(".woff2");
    }

    @Override
    public void destroy() {
        // Clean up resources if needed
    }
}
