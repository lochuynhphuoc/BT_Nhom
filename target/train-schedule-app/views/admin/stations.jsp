<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>Manage Stations - Train Schedule</title>
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

                function openModal(id = null, name = '', city = '') {
                    const modal = document.getElementById('stationModal');
                    const title = document.getElementById('modalTitle');
                    const actionInput = document.getElementById('formAction');
                    const idInput = document.getElementById('stationId');

                    if (id) {
                        title.innerHTML = '<i class="fas fa-edit"></i> Edit Station';
                        actionInput.value = 'update';
                        idInput.value = id;
                        document.getElementById('name').value = name;
                        document.getElementById('city').value = city;
                    } else {
                        title.innerHTML = '<i class="fas fa-plus"></i> Add New Station';
                        actionInput.value = 'add';
                        idInput.value = '';
                        document.getElementById('name').value = '';
                        document.getElementById('city').value = '';
                    }
                    modal.classList.add('active');
                }

                function closeModal() {
                    document.getElementById('stationModal').classList.remove('active');
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
                    if (event.target == document.getElementById('stationModal')) closeModal();
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
                        <i class="fas fa-rocket"></i> ${sessionScope.user.username == 'manager' ? 'Manager Dashboard' :
                        'Admin Dashboard'}
                    </a>
                    <div class="nav-links">
                        <a href="${pageContext.request.contextPath}/admin/trains"><i class="fas fa-train"></i>
                            Trains</a>
                        <a href="${pageContext.request.contextPath}/admin/stations"
                            style="color: var(--primary-color);"><i class="fas fa-map-marker-alt"></i> Stations</a>
                        <a href="${pageContext.request.contextPath}/admin/schedules"><i class="fas fa-calendar-alt"></i>
                            Schedules</a>
                        <a href="${pageContext.request.contextPath}/logout" style="color: var(--danger-color);"><i
                                class="fas fa-sign-out-alt"></i> Logout</a>
                    </div>
                </nav>
                <div class="container fade-in">
                    <div
                        style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
                        <h1>Manage Stations</h1>
                        <div style="display: flex; gap: 1rem;">
                            <div style="display: flex; gap: 0.5rem; align-items: center;">
                                <div style="position: relative;">
                                    <i class="fas fa-search"
                                        style="position: absolute; left: 1rem; top: 50%; transform: translateY(-50%); color: #9ca3af;"></i>
                                    <input type="text" id="searchInput" placeholder="Type to search..."
                                        style="padding: 0.5rem 1rem 0.5rem 2.5rem; border-radius: 8px; border: 1px solid #e5e7eb; width: 250px;">
                                </div>
                            </div>
                            <button onclick="openModal()" class="btn btn-primary"><i class="fas fa-plus"></i> Add New
                                Station</button>
                        </div>
                    </div>

                    <div class="table-container">
                        <table id="dataTable">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Name</th>
                                    <th>City</th>
                                    <th style="text-align: center;">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="s" items="${stations}">
                                    <tr>
                                        <td>${s.id}</td>
                                        <td>${s.name}</td>
                                        <td>${s.city}</td>
                                        <td style="text-align: center;">
                                            <a href="javascript:void(0)"
                                                onclick="openModal('${s.id}', '${s.name}', '${s.city}')"
                                                class="action-btn edit-btn"><i class="fas fa-edit"></i></a>
                                            <a href="javascript:void(0)"
                                                onclick="confirmDelete('${pageContext.request.contextPath}/admin/stations?action=delete&id=${s.id}')"
                                                class="action-btn delete-btn"><i class="fas fa-trash"></i></a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty stations}">
                                    <tr class="no-results">
                                        <td colspan="4" style="text-align: center; padding: 2rem; color: #6b7280;">No
                                            data available.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Edit Modal -->
                <div id="stationModal" class="modal-overlay">
                    <div class="modal">
                        <div
                            style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem;">
                            <h3 id="modalTitle" style="margin: 0;"><i class="fas fa-plus"></i> Add New Station</h3>
                            <button onclick="closeModal()"
                                style="background: none; border: none; font-size: 1.5rem; cursor: pointer; color: var(--text-muted);">&times;</button>
                        </div>
                        <form action="${pageContext.request.contextPath}/admin/stations" method="post">
                            <input type="hidden" name="action" id="formAction" value="add">
                            <input type="hidden" name="id" id="stationId">
                            <div class="form-group">
                                <label>Station Name</label>
                                <div style="position: relative;">
                                    <i class="fas fa-sign"
                                        style="position: absolute; left: 1rem; top: 50%; transform: translateY(-50%); color: #9ca3af;"></i>
                                    <input type="text" name="name" id="name" required
                                        style="padding-left: 2.5rem; width: 100%; box-sizing: border-box;">
                                </div>
                            </div>
                            <div class="form-group">
                                <label>City/Province</label>
                                <div style="position: relative;">
                                    <i class="fas fa-city"
                                        style="position: absolute; left: 1rem; top: 50%; transform: translateY(-50%); color: #9ca3af;"></i>
                                    <input type="text" name="city" id="city" required
                                        style="padding-left: 2.5rem; width: 100%; box-sizing: border-box;">
                                </div>
                            </div>
                            <div style="text-align: right; margin-top: 2rem;">
                                <button type="button" onclick="closeModal()" class="btn"
                                    style="background: #e5e7eb; margin-right: 0.5rem;"><i class="fas fa-times"></i>
                                    Cancel</button>
                                <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Save
                                    Station</button>
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
                            station?</p>
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