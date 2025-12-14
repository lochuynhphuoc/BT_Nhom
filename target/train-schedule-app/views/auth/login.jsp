<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>Login - Train Schedule</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
            <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap"
                rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        </head>

        <body class="auth-body">
            <div class="login-container">
                <div class="login-header">
                    <div style="font-size: 3rem; color: var(--primary-color); margin-bottom: 1rem;">
                        <i class="fas fa-train"></i>
                    </div>
                    <h2>Welcome Back</h2>
                    <p>Sign in to manage your journeys</p>
                </div>

                <c:if test="${not empty error}">
                    <div class="alert alert-danger"
                        style="background:#fee2e2; color:#ef4444; border-left: 4px solid #ef4444; padding: 1rem;">
                        <i class="fas fa-exclamation-circle"></i> ${error}
                    </div>
                </c:if>

                <form action="${pageContext.request.contextPath}/login" method="post" class="login-form">
                    <div class="form-group">
                        <label for="username">Username</label>
                        <div style="position: relative;">
                            <i class="fas fa-user"
                                style="position: absolute; left: 15px; top: 14px; color: var(--text-muted);"></i>
                            <input type="text" id="username" name="username" required placeholder="Enter your username"
                                style="padding-left: 2.5rem;">
                        </div>
                    </div>
                    <div class="form-group">
                        <label for="password">Password</label>
                        <div style="position: relative;">
                            <i class="fas fa-lock"
                                style="position: absolute; left: 15px; top: 14px; color: var(--text-muted);"></i>
                            <input type="password" id="password" name="password" required
                                placeholder="Enter your password" style="padding-left: 2.5rem;">
                        </div>
                    </div>
                    <button type="submit" class="btn btn-primary" style="width: 100%; margin-top: 1rem;">
                        Sign In <i class="fas fa-arrow-right"></i>
                    </button>
                </form>

                <div style="text-align: center; margin-top: 2rem; font-size: 0.9rem; color: var(--text-muted);">
                    <a href="${pageContext.request.contextPath}/"
                        style="color: var(--primary-color); text-decoration: none;">Back to Home</a>
                </div>
            </div>
        </body>

        </html>