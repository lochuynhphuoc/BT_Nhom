<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <!DOCTYPE html>
        <html lang="en">

        <head>
            <meta charset="UTF-8">
            <title>Manage Trains - Train Schedule</title>
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

                function openModal(id = null, code = '', name = '', seats = '') {
                    const modal = document.getElementById('trainModal');
                    const title = document.getElementById('modalTitle');
                    const actionInput = document.getElementById('formAction');
                    const idInput = document.getElementById('trainId');

                    if (id) {
                        title.innerHTML = '<i class="fas fa-edit"></i> Edit Train';
                        actionInput.value = 'update';
                        idInput.value = id;
                        document.getElementById('code').value = code;
                        document.getElementById('name').value = name;
                        document.getElementById('seats').value = seats;
                    } else {
                        title.innerHTML = '<i class="fas fa-plus"></i> Add New Train';
                        actionInput.value = 'add';
                        idInput.value = '';
                        document.getElementById('code').value = '';
                        document.getElementById('name').value = '';
                        document.getElementById('seats').value = '';
                    }
                    modal.classList.add('active');
                }

                function closeModal() {
                    document.getElementById('trainModal').classList.remove('active');
                }

                // Delete Confirmation Modal Logic
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

                // Close when clicking outside
                window.onclick = function (event) {
                    if (event.target == document.getElementById('trainModal')) closeModal();
                    if (event.target == document.getElementById('deleteModal')) closeDeleteModal();
                }

                function openEditModal(element) {
                    const id = element.getAttribute('data-id');
                    const code = element.getAttribute('data-code');
                    const name = element.getAttribute('data-name');
                    const seats = element.getAttribute('data-seats');
                    openModal(id, code, name, seats);
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
                        <a href="${pageContext.request.contextPath}/admin/trains"
                            style="color: var(--primary-color);"><i class="fas fa-train"></i> Trains</a>
                        <a href="${pageContext.request.contextPath}/admin/stations"><i
                                class="fas fa-map-marker-alt"></i> Stations</a>
                        <a href="${pageContext.request.contextPath}/admin/schedules"><i class="fas fa-calendar-alt"></i>
                            Schedules</a>
                        <a href="${pageContext.request.contextPath}/logout" style="color: var(--danger-color);"><i
                                class="fas fa-sign-out-alt"></i> Logout</a>
                    </div>
                </nav>

                <div class="container fade-in">
                    <div
                        style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 2rem;">
                        <h1>Manage Trains</h1>
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
                                Train</button>
                        </div>
                    </div>

                    <div class="table-container">
                        <table id="dataTable">
                            <thead>
                                <tr>
                                    <th>ID</th>
                                    <th>Code</th>
                                    <th>Name</th>
                                    <th>Seats</th>
                                    <th style="text-align: center;">Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <c:forEach var="t" items="${trains}">
                                    <tr>
                                        <td>${t.id}</td>
                                        <td><span
                                                style="background: #e0e7ff; color: #3730a3; padding: 2px 8px; border-radius: 4px; font-weight: 500; font-size: 0.9em;">${t.code}</span>
                                        </td>
                                        <td>${t.name}</td>
                                        <td>${t.totalSeats}</td>
                                        <td style="text-align: center;">
                                            <a href="javascript:void(0)" data-id="${t.id}" data-code="${t.code}"
                                                data-name="${t.name}" data-seats="${t.totalSeats}"
                                                onclick="openEditModal(this)" class="action-btn edit-btn"><i
                                                    class="fas fa-edit"></i></a>
                                            <a href="javascript:void(0)"
                                                onclick="confirmDelete('${pageContext.request.contextPath}/admin/trains?action=delete&id=${t.id}')"
                                                class="action-btn delete-btn"><i class="fas fa-trash"></i></a>
                                        </td>
                                    </tr>
                                </c:forEach>
                                <c:if test="${empty trains}">
                                    <!-- Fallback empty state for server-side empty -->
                                    <tr class="no-results">
                                        <td colspan="5" style="text-align: center; padding: 2rem; color: #6b7280;">No
                                            data available.</td>
                                    </tr>
                                </c:if>
                            </tbody>
                        </table>
                    </div>
                </div>

                <!-- Edit/Add Modal -->
                <div id="trainModal" class="modal-overlay">
                    <div class="modal">
                        <div
                            style="display: flex; justify-content: space-between; align-items: center; margin-bottom: 1.5rem;">
                            <h3 id="modalTitle" style="margin: 0;"><i class="fas fa-plus"></i> Add New Train</h3>
                            <button onclick="closeModal()"
                                style="background: none; border: none; font-size: 1.5rem; cursor: pointer; color: var(--text-muted);">&times;</button>
                        </div>
                        <form action="${pageContext.request.contextPath}/admin/trains" method="post">
                            <input type="hidden" name="action" id="formAction" value="add">
                            <input type="hidden" name="id" id="trainId">
                            <div class="form-group">
                                <label>Code</label>
                                <div style="position: relative;">
                                    <i class="fas fa-barcode"
                                        style="position: absolute; left: 1rem; top: 50%; transform: translateY(-50%); color: #9ca3af;"></i>
                                    <input type="text" name="code" id="code" required
                                        style="padding-left: 2.5rem; width: 100%; box-sizing: border-box;">
                                </div>
                            </div>
                            <div class="form-group">
                                <label>Train Name</label>
                                <div style="position: relative;">
                                    <i class="fas fa-train"
                                        style="position: absolute; left: 1rem; top: 50%; transform: translateY(-50%); color: #9ca3af;"></i>
                                    <input type="text" name="name" id="name" required
                                        style="padding-left: 2.5rem; width: 100%; box-sizing: border-box;">
                                </div>
                            </div>
                            <div class="form-group">
                                <label>Total Seats</label>
                                <div style="position: relative;">
                                    <i class="fas fa-chair"
                                        style="position: absolute; left: 1rem; top: 50%; transform: translateY(-50%); color: #9ca3af;"></i>
                                    <input type="number" name="seats" id="seats" required
                                        style="padding-left: 2.5rem; width: 100%; box-sizing: border-box;">
                                </div>
                            </div>
                            <div style="text-align: right; margin-top: 2rem;">
                                <button type="button" onclick="closeModal()" class="btn"
                                    style="background: #e5e7eb; margin-right: 0.5rem;"><i class="fas fa-times"></i>
                                    Cancel</button>
                                <button type="submit" class="btn btn-primary"><i class="fas fa-save"></i> Save
                                    Train</button>
                            </div>
                        </form>
                    </div>
                </div>

                <!-- Delete Confirmation Modal -->
                <div id="deleteModal" class="modal-overlay" style="z-index: 1001;">
                    <div class="modal" style="max-width: 400px; text-align: center;">
                        <div style="font-size: 3rem; color: var(--danger-color); margin-bottom: 1rem;">
                            <i class="fas fa-exclamation-circle"></i>
                        </div>
                        <h3 style="margin-bottom: 0.5rem;">Are you sure?</h3>
                        <p style="color: var(--text-muted); margin-bottom: 2rem;">Do you really want to delete this
                            train? This process cannot be undone.</p>
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