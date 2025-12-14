<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <title>My Bookings - Train Schedule</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
                <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <script src="${pageContext.request.contextPath}/assets/js/toast.js" defer></script>
                <style>
                    .booking-card-header {
                        padding: 1rem 1.5rem;
                        display: flex;
                        justify-content: space-between;
                        align-items: center;
                    }

                    .booking-card--booked .booking-card-header {
                        background: rgba(16, 185, 129, 0.1);
                        border-bottom: 1px solid rgba(16, 185, 129, 0.2);
                    }

                    .booking-card--canceled .booking-card-header {
                        background: rgba(239, 68, 68, 0.1);
                        border-bottom: 1px solid rgba(239, 68, 68, 0.2);
                    }
                </style>
            </head>

            <body>
                <input type="hidden" id="flash-message" value="${sessionScope.flashMessage}">
                <input type="hidden" id="flash-type" value="${sessionScope.flashType}">
                <% session.removeAttribute("flashMessage"); session.removeAttribute("flashType"); %>

                    <nav class="navbar fade-in">
                        <a href="${pageContext.request.contextPath}/" class="nav-brand">
                            <i class="fas fa-train"></i> NextGen Rails
                        </a>
                        <div class="nav-links">
                            <a href="${pageContext.request.contextPath}/"><i class="fas fa-search"></i> Find Tickets</a>
                            <a href="${pageContext.request.contextPath}/logout" style="color: var(--danger-color);"><i
                                    class="fas fa-sign-out-alt"></i> Logout</a>
                        </div>
                    </nav>

                    <div class="container fade-in" style="margin-top: 2rem;">
                        <div style="display: flex; flex-direction: column; gap: 1rem; margin-bottom: 2rem;">
                            <h1 style="margin: 0;"><i class="fas fa-ticket-alt text-primary"></i> My Bookings</h1>

                            <!-- Search Bar -->
                            <div style="position: relative; max-width: 500px;">
                                <i class="fas fa-search"
                                    style="position: absolute; left: 1.25rem; top: 50%; transform: translateY(-50%); color: var(--text-muted);"></i>
                                <input type="text" id="bookingSearchInput"
                                    placeholder="Search by ID, train, or station..."
                                    style="width: 100%; padding: 0.8rem 1rem 0.8rem 3rem; border: 1px solid #e2e8f0; border-radius: 99px; outline: none; transition: all 0.2s; font-size: 1rem;"
                                    onfocus="this.style.borderColor='var(--primary-color)'; this.style.boxShadow='0 0 0 4px rgba(59, 130, 246, 0.1)';"
                                    onblur="this.style.borderColor='#e2e8f0'; this.style.boxShadow='none';">
                            </div>
                        </div>

                        <c:if test="${empty bookings}">
                            <div class="card" style="text-align: center; padding: 4rem;">
                                <i class="fas fa-history"
                                    style="font-size: 3rem; color: var(--text-muted); opacity: 0.5; margin-bottom: 1rem;"></i>
                                <p>You haven't booked any tickets yet.</p>
                                <a href="${pageContext.request.contextPath}/" class="btn btn-primary"
                                    style="margin-top: 1rem;">Book a Ticket</a>
                            </div>
                        </c:if>

                        <div style="display: grid; gap: 1.5rem;">
                            <c:forEach var="b" items="${bookings}">
                                <c:set var="bookingStatusClass"
                                    value="${b.status eq 'BOOKED' ? 'booked' : 'canceled'}" />
                                <div class="card booking-card booking-card--${bookingStatusClass}"
                                    style="padding: 0; overflow: hidden; display: flex; flex-direction: column;">

                                    <!-- Card Header: Date & Status -->
                                    <div class="booking-card-header">
                                        <div
                                            style="display: flex; align-items: center; gap: 0.75rem; color: var(--text-color);">
                                            <i class="far fa-calendar-alt"
                                                style="font-size: 1.2rem; color: var(--primary-color);"></i>
                                            <span style="font-weight: 700; font-size: 1.1rem;">
                                                <fmt:formatDate value="${b.schedule.departureTime}"
                                                    pattern="EEEE, dd MMMM yyyy" />
                                            </span>
                                        </div>
                                        <div style="display: flex; align-items: center; gap: 1rem;">
                                            <span
                                                style="font-size: 0.85rem; color: var(--text-muted); font-weight: 500;">ID:
                                                #${b.id}</span>
                                            <span class="booking-status booking-status--${bookingStatusClass}">
                                                ${b.status}
                                            </span>
                                        </div>
                                    </div>

                                    <!-- Card Body: Train & Route -->
                                    <div style="padding: 1.5rem; flex: 1;">
                                        <div
                                            style="display: flex; align-items: center; justify-content: space-between; gap: 2rem;">
                                            <!-- Train Code -->
                                            <div style="text-align: center; min-width: 80px;">
                                                <div
                                                    style="background: var(--bg-color); width: 60px; height: 60px; border-radius: 12px; display: flex; align-items: center; justify-content: center; margin: 0 auto 0.5rem;">
                                                    <i class="fas fa-subway"
                                                        style="font-size: 1.8rem; color: var(--primary-color);"></i>
                                                </div>
                                                <h3 style="margin: 0; font-size: 1.25rem;">${b.schedule.train.code}</h3>
                                                <p style="margin: 0; font-size: 0.8rem; color: var(--text-muted);">
                                                    ${b.schedule.train.name}</p>
                                            </div>

                                            <!-- Route Diagram -->
                                            <div
                                                style="flex: 1; display: flex; align-items: center; justify-content: space-between; background: #f8fafc; padding: 1.5rem; border-radius: 16px;">
                                                <div style="text-align: left;">
                                                    <div
                                                        style="font-size: 1.5rem; font-weight: 800; color: var(--text-color); line-height: 1;">
                                                        <fmt:formatDate value="${b.schedule.departureTime}"
                                                            pattern="HH:mm" />
                                                    </div>
                                                    <div
                                                        style="color: var(--text-muted); font-size: 0.9rem; margin-top: 0.25rem;">
                                                        ${b.schedule.departureStation.name}</div>
                                                </div>

                                                <div
                                                    style="flex: 1; display: flex; flex-direction: column; align-items: center; padding: 0 1.5rem;">
                                                    <div
                                                        style="font-size: 0.8rem; color: var(--text-muted); margin-bottom: 0.25rem;">
                                                        Direct</div>
                                                    <div
                                                        style="width: 100%; height: 2px; background: #e2e8f0; position: relative;">
                                                        <div
                                                            style="position: absolute; right: 0; top: 50%; transform: translateY(-50%); width: 0; height: 0; border-top: 5px solid transparent; border-bottom: 5px solid transparent; border-left: 6px solid #e2e8f0;">
                                                        </div>
                                                    </div>
                                                </div>

                                                <div style="text-align: right;">
                                                    <div
                                                        style="font-size: 1.5rem; font-weight: 800; color: var(--text-color); line-height: 1;">
                                                        <fmt:formatDate value="${b.schedule.arrivalTime}"
                                                            pattern="HH:mm" />
                                                    </div>
                                                    <div
                                                        style="color: var(--text-muted); font-size: 0.9rem; margin-top: 0.25rem;">
                                                        ${b.schedule.arrivalStation.name}</div>
                                                </div>
                                            </div>

                                            <!-- Ticket Badge -->
                                            <div style="min-width: 100px; text-align: center;">
                                                <div
                                                    style="border: 2px dashed #cbd5e1; border-radius: 12px; padding: 0.75rem;">
                                                    <div
                                                        style="font-size: 1.5rem; font-weight: 800; color: var(--primary-color);">
                                                        ${b.quantity}
                                                    </div>
                                                    <div
                                                        style="font-size: 0.8rem; color: var(--text-muted); text-transform: uppercase; letter-spacing: 0.5px;">
                                                        Tickets</div>
                                                </div>
                                            </div>
                                        </div>
                                    </div>

                                    <!-- Card Footer: Price & Actions -->
                                    <div
                                        style="padding: 1rem 1.5rem; background: #f8fafc; border-top: 1px solid var(--border-color); display: flex; justify-content: space-between; align-items: center;">
                                        <div>
                                            <span
                                                style="display: block; font-size: 0.8rem; color: var(--text-muted);">Total
                                                Price</span>
                                            <span
                                                style="font-size: 1.5rem; font-weight: 800; color: var(--primary-color);">
                                                <fmt:formatNumber value="${b.totalPrice}" type="currency"
                                                    maxFractionDigits="0" currencySymbol="₫" />
                                            </span>
                                        </div>

                                        <div style="display:flex; gap: 0.75rem;">
                                            <fmt:formatDate value="${b.schedule.departureTime}"
                                                pattern="HH:mm - dd/MM/yyyy" var="dTime" />

                                            <button class="btn"
                                                style="padding: 0.6rem 1.25rem; font-size: 0.9rem; background: white; border: 1px solid #e2e8f0; color: var(--text-color); border-radius: 8px; font-weight: 600; box-shadow: 0 1px 2px rgba(0,0,0,0.05);"
                                                onclick="openDetailModal('${b.schedule.train.code}', '${b.schedule.departureStation.name}', '${b.schedule.arrivalStation.name}', '${dTime}', '${b.fullName}', '${b.idCard}', '${b.phone}', '${b.email}', '${b.quantity}', '${b.notes}', '${b.totalPrice}', '${b.paymentMethod}', '${b.status}')">
                                                <i class="far fa-eye" style="margin-right: 0.5rem;"></i> Details
                                            </button>

                                            <c:if test="${b.status eq 'BOOKED'}">
                                                <button type="button" class="btn" onclick="confirmCancel('${b.id}')"
                                                    style="padding: 0.6rem 1.25rem; font-size: 0.9rem; background: white; border: 1px solid var(--danger-color); color: var(--danger-color); border-radius: 8px; font-weight: 600; box-shadow: 0 1px 2px rgba(0,0,0,0.05);">
                                                    Cancel
                                                </button>
                                            </c:if>
                                        </div>
                                    </div>
                                </div>
                            </c:forEach>
                        </div>
                    </div>

                    <!-- Detail Modal -->
                    <div id="detail-modal-overlay" class="modal-overlay">
                        <div class="modal">
                            <div class="modal-header">
                                <h3 style="margin:0; font-size:1.25rem;">Booking Details</h3>
                                <button type="button" onclick="closeDetailModal()"
                                    style="background:transparent; border:none; color:white; font-size:1.5rem; cursor:pointer;">&times;</button>
                            </div>
                            <div class="modal-body">
                                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 1.5rem;">
                                    <div>
                                        <h4
                                            style="color:var(--primary-color); margin-bottom:0.5rem; border-bottom: 2px solid #f3f4f6; padding-bottom:0.5rem;">
                                            Train Info</h4>
                                        <p><strong>Code:</strong> <span id="d-train"></span></p>
                                        <p><strong>Route:</strong> <span id="d-route"></span></p>
                                        <p><strong>Time:</strong> <span id="d-time"></span></p>
                                        <p><strong>Status:</strong> <span id="d-status"></span></p>
                                    </div>
                                    <div>
                                        <h4
                                            style="color:var(--primary-color); margin-bottom:0.5rem; border-bottom: 2px solid #f3f4f6; padding-bottom:0.5rem;">
                                            Payment</h4>
                                        <p><strong>Method:</strong> <span id="d-payment"></span></p>
                                        <p><strong>Total:</strong> <span id="d-total"
                                                style="font-weight:700; color:var(--success-color);"></span></p>
                                    </div>
                                    <div style="grid-column: span 2;">
                                        <h4
                                            style="color:var(--primary-color); margin-bottom:0.5rem; border-bottom: 2px solid #f3f4f6; padding-bottom:0.5rem;">
                                            Passenger Info</h4>
                                        <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 0.5rem;">
                                            <p><strong>Name:</strong> <span id="d-name"></span></p>
                                            <p><strong>Phone:</strong> <span id="d-phone"></span></p>
                                            <p><strong>ID Card:</strong> <span id="d-idcard"></span></p>
                                            <p><strong>Email:</strong> <span id="d-email"></span></p>
                                        </div>
                                    </div>
                                    <div style="grid-column: span 2;">
                                        <h4
                                            style="color:var(--primary-color); margin-bottom:0.5rem; border-bottom: 2px solid #f3f4f6; padding-bottom:0.5rem;">
                                            Ticket Info</h4>
                                        <p><strong>Quantity:</strong> <span id="d-quantity"></span></p>
                                        <p><strong>Notes:</strong> <span id="d-notes"
                                                style="font-style:italic; color:var(--text-muted);"></span></p>
                                    </div>
                                </div>
                            </div>
                            <div
                                style="padding: 1rem; text-align: right; background: #f8fafc; border-top: 1px solid var(--border-color);">
                                <button class="btn btn-primary" onclick="closeDetailModal()">Close</button>
                            </div>
                        </div>
                    </div>

                    <script>
                        function openDetailModal(train, dep, arr, time, name, idcard, phone, email, quantity, notes, total, payment, status) {
                            document.getElementById('d-train').innerText = train;
                            document.getElementById('d-route').innerText = dep + ' ➝ ' + arr;
                            document.getElementById('d-time').innerText = time;
                            document.getElementById('d-status').innerText = status;

                            const formatter = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND', maximumFractionDigits: 0 });
                            document.getElementById('d-total').innerText = formatter.format(total);
                            document.getElementById('d-payment').innerText = payment || 'N/A';

                            document.getElementById('d-name').innerText = name || 'N/A';
                            document.getElementById('d-phone').innerText = phone || 'N/A';
                            document.getElementById('d-idcard').innerText = idcard || 'N/A';
                            document.getElementById('d-email').innerText = email || 'N/A';

                            document.getElementById('d-quantity').innerText = quantity;
                            document.getElementById('d-notes').innerText = notes || 'None';

                            document.getElementById('detail-modal-overlay').classList.add('active');
                        }

                        function closeDetailModal() {
                            document.getElementById('detail-modal-overlay').classList.remove('active');
                        }

                        // Cancel Confirmation Logic
                        function confirmCancel(bookingId) {
                            document.getElementById('cancel-booking-id').value = bookingId;
                            document.getElementById('confirmModal').classList.add('active');
                        }

                        function closeConfirmModal() {
                            document.getElementById('confirmModal').classList.remove('active');
                        }

                        // Close modal on click outside
                        window.onclick = function (event) {
                            const detailModal = document.getElementById('detail-modal-overlay');
                            const confirmModal = document.getElementById('confirmModal');
                            if (event.target == detailModal) {
                                closeDetailModal();
                            }
                            if (event.target == confirmModal) {
                                closeConfirmModal();
                            }
                        }

                        // Search Filtering
                        document.getElementById('bookingSearchInput').addEventListener('keyup', function () {
                            const query = this.value.toLowerCase();
                            const cards = document.querySelectorAll('.booking-card');

                            cards.forEach(card => {
                                const text = card.innerText.toLowerCase();
                                if (text.includes(query)) {
                                    card.style.display = 'flex';
                                } else {
                                    card.style.display = 'none';
                                }
                            });
                        });
                    </script>

                    <!-- Confirmation Modal -->
                    <div id="confirmModal" class="modal-overlay" style="z-index: 1100;">
                        <div class="modal"
                            style="width: 90%; max-width: 500px; background: white; border-radius: 16px; overflow: hidden; box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25);">

                            <div class="modal-header"
                                style="padding: 1.5rem; background: #fff1f2; color: #9f1239; display: flex; align-items: center; gap: 1rem; border-bottom: 1px solid #fecdd3;">
                                <div
                                    style="width: 40px; height: 40px; background: white; border-radius: 50%; display: flex; align-items: center; justify-content: center; box-shadow: 0 2px 4px rgba(0,0,0,0.05);">
                                    <i class="fas fa-exclamation-triangle"
                                        style="color: #e11d48; font-size: 1.2rem;"></i>
                                </div>
                                <div>
                                    <h3 style="margin: 0; font-size: 1.25rem; font-weight: 700;">Cancel Booking?</h3>
                                    <p style="margin: 0; font-size: 0.9rem; opacity: 0.9;">This action cannot be undone.
                                    </p>
                                </div>
                            </div>

                            <div class="modal-body" style="padding: 1.5rem;">
                                <p style="color: var(--text-color); margin-bottom: 1.5rem; line-height: 1.5;">
                                    You are about to cancel this booking. Please select how you would like to receive
                                    your refund:
                                </p>

                                <form action="${pageContext.request.contextPath}/bookings" method="post"
                                    id="cancelForm">
                                    <input type="hidden" name="action" value="cancel">
                                    <input type="hidden" name="bookingId" id="cancel-booking-id">

                                    <div
                                        style="display: flex; flex-direction: column; gap: 0.75rem; margin-bottom: 2rem;">
                                        <label class="payment-option"
                                            style="display:flex; align-items:center; gap:1rem; padding:1rem; border:1px solid #e2e8f0; border-radius:10px; cursor:pointer; transition: all 0.2s;">
                                            <input type="radio" name="refundMethod" value="original" checked
                                                style="width: 1.1rem; height: 1.1rem; accent-color: var(--primary-color);">
                                            <div style="display: flex; flex-direction: column;">
                                                <span style="font-weight: 600; color: var(--text-color);">Original
                                                    Payment Method</span>
                                                <span style="font-size: 0.8rem; color: #64748b;">Refund within 3-5
                                                    business days</span>
                                            </div>
                                        </label>

                                        <label class="payment-option"
                                            style="display:flex; align-items:center; gap:1rem; padding:1rem; border:1px solid #e2e8f0; border-radius:10px; cursor:pointer; transition: all 0.2s;">
                                            <input type="radio" name="refundMethod" value="wallet"
                                                style="width: 1.1rem; height: 1.1rem; accent-color: var(--primary-color);">
                                            <div style="display: flex; flex-direction: column;">
                                                <span style="font-weight: 600; color: var(--text-color);">AnyRail Wallet
                                                    Credit</span>
                                                <span style="font-size: 0.8rem; color: #64748b;">Instant refund, use for
                                                    next trip</span>
                                            </div>
                                            <span
                                                style="margin-left:auto; background:#dcfce7; color:#166534; font-size:0.7rem; padding:0.2rem 0.5rem; border-radius:4px; font-weight:600;">RECOMMENDED</span>
                                        </label>

                                        <label class="payment-option"
                                            style="display:flex; align-items:center; gap:1rem; padding:1rem; border:1px solid #e2e8f0; border-radius:10px; cursor:pointer; transition: all 0.2s;">
                                            <input type="radio" name="refundMethod" value="bank"
                                                style="width: 1.1rem; height: 1.1rem; accent-color: var(--primary-color);">
                                            <div style="display: flex; flex-direction: column;">
                                                <span style="font-weight: 600; color: var(--text-color);">Bank
                                                    Transfer</span>
                                                <span style="font-size: 0.8rem; color: #64748b;">Manual processing (5-7
                                                    days)</span>
                                            </div>
                                        </label>
                                    </div>

                                    <div style="display: flex; justify-content: flex-end; gap: 1rem;">
                                        <button type="button" onclick="closeConfirmModal()" class="btn"
                                            style="padding: 0.75rem 1.5rem; background: white; border: 1px solid #cbd5e1; color: #64748b; border-radius: 8px; font-weight: 600;">
                                            No, Keep Booking
                                        </button>
                                        <button type="submit" class="btn"
                                            style="padding: 0.75rem 1.5rem; background: #e11d48; color: white; border: none; border-radius: 8px; font-weight: 600; box-shadow: 0 4px 6px -1px rgba(225, 29, 72, 0.3);">
                                            Confirm Cancellation
                                        </button>
                                    </div>
                                </form>
                            </div>
                        </div>
                    </div>
            </body>

            </html>