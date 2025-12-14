<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>Admin Dashboard - Train Schedule</title>
            <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
            <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap"
                rel="stylesheet">
            <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
        </head>

        <body>
            <nav class="navbar fade-in">
                <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-brand">
                    <i class="fas fa-rocket"></i> ${sessionScope.user.username == 'manager' ? 'Manager Dashboard' :
                    'Admin Dashboard'}
                </a>
                <div class="nav-links">
                    <a href="${pageContext.request.contextPath}/admin/trains"><i class="fas fa-train"></i> Trains</a>
                    <a href="${pageContext.request.contextPath}/admin/stations"><i class="fas fa-map-marker-alt"></i>
                        Stations</a>
                    <a href="${pageContext.request.contextPath}/admin/schedules"><i class="fas fa-calendar-alt"></i>
                        Schedules</a>
                    <a href="${pageContext.request.contextPath}/logout" style="color: var(--danger-color);"><i
                            class="fas fa-sign-out-alt"></i> Logout</a>
                </div>
            </nav>

            <div class="container fade-in" style="animation-delay: 0.2s;">
                <div style="display: flex; align-items: center; gap: 1rem; margin-bottom: 2rem;">
                    <div
                        style="width: 50px; height: 50px; background: #e0e7ff; color: var(--primary-color); border-radius: 50%; display: flex; align-items: center; justify-content: center; font-size: 1.5rem;">
                        <i class="fas fa-user-shield"></i>
                    </div>
                    <div>
                        <h1 style="margin: 0; font-size: 1.8rem;">Welcome, ${sessionScope.user.fullName}</h1>
                        <p style="color: var(--text-muted); margin: 0;">System Overview</p>
                    </div>
                </div>

                <div style="display: grid; grid-template-columns: repeat(auto-fit, minmax(300px, 1fr)); gap: 1.5rem;">
                    <!-- Trains Card -->
                    <div class="card" style="padding: 2rem; position: relative; overflow: hidden;">
                        <div
                            style="position: absolute; right: -20px; top: -20px; font-size: 8rem; color: rgba(0,0,0,0.03); transform: rotate(15deg);">
                            <i class="fas fa-train"></i>
                        </div>
                        <div
                            style="width: 60px; height: 60px; background: #dbeafe; color: #2563eb; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; margin-bottom: 1.5rem;">
                            <i class="fas fa-train"></i>
                        </div>
                        <h3>Manage Trains</h3>
                        <p style="margin: 0.5rem 0 1.5rem; color: var(--text-muted);">Add, edit, or remove trains from
                            the fleet. Monitor capacity.</p>
                        <a href="${pageContext.request.contextPath}/admin/trains" class="btn btn-primary"
                            style="width: 100%;">
                            Go to Trains <i class="fas fa-arrow-right"></i>
                        </a>
                    </div>

                    <!-- Stations Card -->
                    <div class="card" style="padding: 2rem; position: relative; overflow: hidden;">
                        <div
                            style="position: absolute; right: -20px; top: -20px; font-size: 8rem; color: rgba(0,0,0,0.03); transform: rotate(15deg);">
                            <i class="fas fa-building"></i>
                        </div>
                        <div
                            style="width: 60px; height: 60px; background: #fce7f3; color: #db2777; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; margin-bottom: 1.5rem;">
                            <i class="fas fa-map-marked-alt"></i>
                        </div>
                        <h3>Manage Stations</h3>
                        <p style="margin: 0.5rem 0 1.5rem; color: var(--text-muted);">Update station information and
                            geographic locations.</p>
                        <a href="${pageContext.request.contextPath}/admin/stations" class="btn btn-primary"
                            style="background: linear-gradient(135deg, #ec4899, #db2777); width: 100%;">
                            Go to Stations <i class="fas fa-arrow-right"></i>
                        </a>
                    </div>

                    <!-- Schedules Card -->
                    <div class="card" style="padding: 2rem; position: relative; overflow: hidden;">
                        <div
                            style="position: absolute; right: -20px; top: -20px; font-size: 8rem; color: rgba(0,0,0,0.03); transform: rotate(15deg);">
                            <i class="fas fa-clock"></i>
                        </div>
                        <div
                            style="width: 60px; height: 60px; background: #d1fae5; color: #059669; border-radius: 12px; display: flex; align-items: center; justify-content: center; font-size: 1.5rem; margin-bottom: 1.5rem;">
                            <i class="fas fa-calendar-check"></i>
                        </div>
                        <h3>Manage Schedules</h3>
                        <p style="margin: 0.5rem 0 1.5rem; color: var(--text-muted);">Set departure times, assign trains
                            and manage pricing.</p>
                        <a href="${pageContext.request.contextPath}/admin/schedules" class="btn btn-primary"
                            style="background: linear-gradient(135deg, #10b981, #059669); width: 100%;">
                            Go to Schedules <i class="fas fa-arrow-right"></i>
                        </a>
                    </div>
                </div>
            </div>
        </body>

        </html>