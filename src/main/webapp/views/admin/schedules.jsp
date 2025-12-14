<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <title>Manage Schedules - Train Schedule</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
                <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <script src="${pageContext.request.contextPath}/assets/js/toast.js" defer></script>
                <script src="${pageContext.request.contextPath}/assets/js/search.js" defer></script>
                <script>
                    document.addEventListener('DOMContentLoaded', () => {
                        setupSearch('searchInput', 'dataTable');
                    });

                    function openModal() {
                        document.getElementById('scheduleModal').classList.add('active');
                    }

                    function closeModal() {
                        document.getElementById('scheduleModal').classList.remove('active');
                    }

                    // Delete Modal Logic
                    let deleteUrl = '';
                    function confirmDelete(url) {
                        deleteUrl = url;
                        document.getElementById('deleteModal').classList.add('active');
                    }
                    function closeDeleteModal() {
                        document.getElementById('deleteModal').classList.remove('active');
                    }
                    function executeDelete() {
                        window.location.href = deleteUrl;
                    }

                    window.onclick = function (event) {
                        if (event.target == document.getElementById('scheduleModal')) closeModal();
                        if (event.target == document.getElementById('deleteModal')) closeDeleteModal();
                    }
                </script>
            </head>

            <body>
                <input type="hidden" id="flash-message" value="${sessionScope.flashMessage}">
                <input type="hidden" id="flash-type" value="${sessionScope.flashType}">
                <% session.removeAttribute("flashMessage"); session.removeAttribute("flashType"); %>

                    <nav class="navbar">
                        <a href="${pageContext.request.contextPath}/admin/dashboard" class="nav-brand">
                            <i class="fas fa-rocket"></i> ${sessionScope.user.username == 'manager' ? 'Manager
                            Dashboard' : 'Admin Dashboard'}
                        </a>
                        <div class="nav-links">
                            <a href="${pageContext.request.contextPath}/admin/trains"><i class="fas fa-train"></i>
                                Trains</a>
                            <a href="${pageContext.request.contextPath}/admin/stations"><i
                                    class="fas fa-map-marker-alt"></i> Stations</a>
                            <a href="${pageContext.request.contextPath}/admin/schedules"
                                style="color: var(--primary-color);"><i class="fas fa-calendar-alt"></i> Schedules</a>
                            <a href="${pageContext.request.contextPath}/logout" style="color: var(--danger-color);"><i
                                    class="fas fa-sign-out-alt"></i> Logout</a>
                        </div>
                    </nav>
                    <div class="container fade-in">
                        <div
                            style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
                            <h1>Manage Schedules</h1>
                            <div style="display: flex; gap: 1rem;">
                                <div style="display: flex; gap: 0.5rem; align-items: center;">
                                    <div style="position: relative;">
                                        <i class="fas fa-search"
                                            style="position: absolute; left: 1rem; top: 50%; transform: translateY(-50%); color: #9ca3af;"></i>
                                        <input type="text" id="searchInput" placeholder="Type to search..."
                                            style="padding: 0.5rem 1rem 0.5rem 2.5rem; border-radius: 8px; border: 1px solid #e5e7eb; width: 250px;">
                                    </div>
                                </div>
                                <button onclick="openModal()" class="btn btn-primary"><i class="fas fa-plus"></i> Add
                                    New Schedule</button>
                            </div>
                        </div>

                        <div class="table-container">
                            <table id="dataTable">
                                <thead>
                                    <tr>
                                        <th>Train</th>
                                        <th>Route</th>
                                        <th>Departs</th>
                                        <th>Arrives</th>
                                        <th>Price</th>
                                        <th style="text-align: center;">Actions</th>
                                    </tr>
                                </thead>
                                <tbody>
                                    <c:forEach var="s" items="${schedules}">
                                        <tr>
                                            <td><strong>${s.train.code}</strong><br><small
                                                    style="color:var(--text-muted)">${s.train.name}</small></td>
                                            <td>
                                                <div><span style="color:#10b981">From:</span> ${s.departureStation.name}
                                                </div>
                                                <div><span style="color:#ef4444">To:</span> ${s.arrivalStation.name}
                                                </div>
                                            </td>
                                            <td>
                                                <fmt:formatDate value="${s.departureTime}"
                                                    pattern="dd-MM-yyyy HH:mm:ss" />
                                            </td>
                                            <td>
                                                <fmt:formatDate value="${s.arrivalTime}"
                                                    pattern="dd-MM-yyyy HH:mm:ss" />
                                            </td>
                                            <td>
                                                <fmt:formatNumber value="${s.price}" type="currency" currencySymbol="₫"
                                                    maxFractionDigits="0" />
                                            </td>
                                            <td style="text-align: center;">
                                                <a href="javascript:void(0)"
                                                    onclick="confirmDelete('${pageContext.request.contextPath}/admin/schedules?action=delete&id=${s.id}')"
                                                    class="action-btn delete-btn"><i class="fas fa-trash"></i></a>
                                            </td>
                                        </tr>
                                    </c:forEach>
                                    <c:if test="${empty schedules}">
                                        <tr class="no-results">
                                            <td colspan="6" style="text-align: center; padding: 2rem; color: #6b7280;">
                                                No data available.</td>
                                        </tr>
                                    </c:if>
                                </tbody>
                            </table>
                        </div>
                    </div>

                    <!-- Add Modal -->
                    <div id="scheduleModal" class="modal-overlay">
                        <div class="modal" style="max-width: 600px;">
                            <div
                                style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem;">
                                <h3 style="margin: 0;"><i class="fas fa-plus"></i> Add New Schedule</h3>
                                <button onclick="closeModal()"
                                    style="background: none; border: none; font-size: 1.5rem; cursor: pointer; color: var(--text-muted);">&times;</button>
                            </div>
                            <form action="${pageContext.request.contextPath}/admin/schedules" method="post">
                                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1rem;">
                                    <div class="form-group" style="grid-column: span 2;">
                                        <label>Train</label>
                                        <div style="position: relative;">
                                            <i class="fas fa-train"
                                                style="position: absolute; left: 1rem; top: 50%; transform: translateY(-50%); color: #9ca3af;"></i>
                                            <select name="trainId" required
                                                style="padding-left: 2.5rem; width: 100%; box-sizing: border-box;">
                                                <c:forEach var="t" items="${trains}">
                                                    <option value="${t.id}">${t.code} - ${t.name}</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label>Departure Station</label>
                                        <div style="position: relative;">
                                            <i class="fas fa-map-marker-alt"
                                                style="position: absolute; left: 1rem; top: 50%; transform: translateY(-50%); color: #10b981;"></i>
                                            <select name="depId" required
                                                style="padding-left: 2.5rem; width: 100%; box-sizing: border-box;">
                                                <c:forEach var="s" items="${stations}">
                                                    <option value="${s.id}">${s.name} (${s.city})</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label>Arrival Station</label>
                                        <div style="position: relative;">
                                            <i class="fas fa-map-marker-alt"
                                                style="position: absolute; left: 1rem; top: 50%; transform: translateY(-50%); color: #ef4444;"></i>
                                            <select name="arrId" required
                                                style="padding-left: 2.5rem; width: 100%; box-sizing: border-box;">
                                                <c:forEach var="s" items="${stations}">
                                                    <option value="${s.id}">${s.name} (${s.city})</option>
                                                </c:forEach>
                                            </select>
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label>Departure Time</label>
                                        <div style="position: relative;">
                                            <i class="fas fa-clock"
                                                style="position: absolute; left: 1rem; top: 50%; transform: translateY(-50%); color: #9ca3af;"></i>
                                            <input type="datetime-local" name="depTime" required
                                                style="padding-left: 2.5rem; width: 100%; box-sizing: border-box;">
                                        </div>
                                    </div>
                                    <div class="form-group">
                                        <label>Arrival Time</label>
                                        <div style="position: relative;">
                                            <i class="fas fa-clock"
                                                style="position: absolute; left: 1rem; top: 50%; transform: translateY(-50%); color: #9ca3af;"></i>
                                            <input type="datetime-local" name="arrTime" required
                                                style="padding-left: 2.5rem; width: 100%; box-sizing: border-box;">
                                        </div>
                                    </div>
                                    <div class="form-group" style="grid-column: span 2;">
                                        <label>Price (VND)</label>
                                        <div style="position: relative;">
                                            <i class="fas fa-tag"
                                                style="position: absolute; left: 1rem; top: 50%; transform: translateY(-50%); color: #9ca3af;"></i>
                                            <input type="number" name="price" required
                                                style="padding-left: 2.5rem; width: 100%; box-sizing: border-box;">
                                        </div>
                                    </div>
                                </div>
                                <div style="text-align: right; margin-top: 2rem;">
                                    <button type="button" onclick="closeModal()" class="btn"
                                        style="background: #e5e7eb; margin-right: 0.5rem;"><i class="fas fa-times"></i>
                                        Cancel</button>
                                    <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Save
                                        Schedule</button>
                                </div>
                            </form>
                        </div>
                    </div>

                    <!-- Delete Modal -->
                    <div id="deleteModal" class="modal-overlay" style="z-index: 1001;">
                        <div class="modal" style="max-width: 400px; text-align: center;">
                            <div style="font-size: 3rem; color: var(--danger-color); margin-bottom: 1rem;">
                                <i class="fas fa-exclamation-circle"></i>
                            </div>
                            <h3 style="margin-bottom: 0.5rem;">Are you sure?</h3>
                            <p style="color: var(--text-muted); margin-bottom: 2rem;">Do you really want to delete this
                                schedule?</p>
                            <div style="display: flex; justify-content: center; gap: 1rem;">
                                <button onclick="closeDeleteModal()" class="btn" style="background: #e5e7eb;"><i
                                        class="fas fa-times"></i> Cancel</button>
                                <button onclick="executeDelete()" class="btn"
                                    style="background: var(--danger-color); color: white;"><i class="fas fa-trash"></i>
                                    Delete</button>
                            </div>
                        </div>
                    </div>
            </body>

            </html>