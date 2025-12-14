<%@ page contentType="text/html;charset=UTF-8" language="java" %>
    <%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
        <%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %>
            <!DOCTYPE html>
            <html lang="en">

            <head>
                <meta charset="UTF-8">
                <title>Find Train Tickets - Train Schedule</title>
                <link rel="stylesheet" href="${pageContext.request.contextPath}/assets/css/style.css">
                <link href="https://fonts.googleapis.com/css2?family=Outfit:wght@300;400;500;600;700&display=swap"
                    rel="stylesheet">
                <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
                <script src="${pageContext.request.contextPath}/assets/js/toast.js" defer></script>
            </head>

            <body>
                <!-- Flash Message Handling -->
                <input type="hidden" id="flash-message" value="${sessionScope.flashMessage}">
                <input type="hidden" id="flash-type" value="${sessionScope.flashType}">
                <% session.removeAttribute("flashMessage"); session.removeAttribute("flashType"); %>

                    <div class="hero-section">
                        <div style="position: absolute; top: 20px; right: 30px;">
                            <c:choose>
                                <c:when test="${not empty sessionScope.user}">
                                    <span style="margin-right: 15px; font-weight: 500;"><i
                                            class="fas fa-user-circle"></i> ${sessionScope.user.fullName}</span>
                                    <a href="${pageContext.request.contextPath}/bookings" class="glass-box btn"
                                        style="text-decoration:none; color:white; padding: 0.5rem 1rem; margin-right: 0.5rem;">
                                        <i class="fas fa-ticket-alt"></i> My Bookings
                                    </a>
                                    <c:if test="${sessionScope.user.roleId == 1}">
                                        <a href="${pageContext.request.contextPath}/admin/dashboard"
                                            class="glass-box btn"
                                            style="text-decoration:none; color:white; padding: 0.5rem 1rem; margin-right: 0.5rem;">
                                            <i class="fas fa-tachometer-alt"></i> Dashboard
                                        </a>
                                    </c:if>
                                    <a href="${pageContext.request.contextPath}/logout" class="glass-box btn"
                                        style="text-decoration:none; color:white; padding: 0.5rem 1rem;">
                                        <i class="fas fa-sign-out-alt"></i> Logout
                                    </a>
                                </c:when>
                                <c:otherwise>
                                    <a href="${pageContext.request.contextPath}/login" class="glass-box btn"
                                        style="text-decoration:none; color:white; padding: 0.5rem 1rem;">
                                        <i class="fas fa-sign-in-alt"></i> Sign In
                                    </a>
                                </c:otherwise>
                            </c:choose>
                        </div>

                        <h1 class="fade-in"
                            style="font-size: 3.5rem; margin-bottom: 0.5rem; text-shadow: 0 4px 6px rgba(0,0,0,0.1);">
                            NextGen Rails <i class="fas fa-train"></i>
                        </h1>
                        <p class="fade-in" style="font-size: 1.25rem; opacity: 0.9; animation-delay: 0.1s;">
                            Experience the future of travel. Fast, comfortable, and reliable.
                        </p>
                    </div>

                    <!-- Search Box overlapping hero -->
                    <div class="container fade-in" style="animation-delay: 0.2s;">
                        <form action="${pageContext.request.contextPath}/" method="get" class="search-box">
                            <div class="form-group" style="margin:0;">
                                <label
                                    style="color: var(--text-color); margin-bottom: 0.5rem; display:block; font-weight:600;">
                                    <i class="fas fa-map-marker-alt" style="color:var(--primary-color)"></i> From
                                </label>
                                <input type="text" name="from" placeholder="City or Station" value="${param.from}"
                                    style="background:#f3f4f6;">
                            </div>
                            <div class="form-group" style="margin:0;">
                                <label
                                    style="color: var(--text-color); margin-bottom: 0.5rem; display:block; font-weight:600;">
                                    <i class="fas fa-map-marker" style="color:var(--secondary-color)"></i> To
                                </label>
                                <input type="text" name="to" placeholder="City or Station" value="${param.to}"
                                    style="background:#f3f4f6;">
                            </div>
                            <div class="form-group" style="margin:0;">
                                <label
                                    style="color: var(--text-color); margin-bottom: 0.5rem; display:block; font-weight:600;">
                                    <i class="far fa-calendar-alt" style="color:var(--primary-color)"></i> Date
                                </label>
                                <input type="date" name="date" value="${param.date}" style="background:#f3f4f6;">
                            </div>
                            <button type="submit" class="btn btn-primary" style="height: 50px;">
                                <i class="fas fa-search"></i> Search Tickets
                            </button>
                        </form>
                    </div>

                    <div class="container fade-in" style="margin-top: 4rem; animation-delay: 0.4s;">
                        <h2 style="margin-bottom: 1.5rem; font-weight: 700; color: var(--text-color);">
                            <i class="fas fa-clock" style="color: var(--primary-color); margin-right: 0.5rem;"></i>
                            Available Schedules
                        </h2>

                        <c:if test="${empty schedules}">
                            <div class="card" style="text-align: center; padding: 4rem;">
                                <i class="fas fa-search"
                                    style="font-size: 3rem; color: var(--text-muted); margin-bottom: 1rem; opacity: 0.5;"></i>
                                <p style="color: var(--text-muted); font-size: 1.1rem;">No schedules found matching your
                                    criteria.</p>
                            </div>
                        </c:if>

                        <c:if test="${not empty schedules}">
                            <div style="display: grid; gap: 1.5rem;">
                                <c:forEach var="s" items="${schedules}">
                                    <div class="card"
                                        style="padding: 1.5rem; display: grid; grid-template-columns: 2fr 3fr 1fr; gap: 2rem; align-items: center;">
                                        <!-- Train Info -->
                                        <div style="display: flex; align-items: center; gap: 1rem;">
                                            <div
                                                style="background: linear-gradient(135deg, var(--primary-color), var(--secondary-color)); width: 60px; height: 60px; border-radius: 12px; display: flex; align-items: center; justify-content: center; color: white; font-size: 1.5rem; box-shadow: 0 4px 6px rgba(0,0,0,0.1);">
                                                <i class="fas fa-subway"></i>
                                            </div>
                                            <div>
                                                <h3 style="margin: 0; color: var(--text-color);">${s.train.code}</h3>
                                                <div style="color: var(--text-muted); font-size: 0.9rem;">
                                                    ${s.train.name}
                                                </div>
                                                <div
                                                    style="color: var(--text-muted); font-size: 0.9rem; margin-top: 0.25rem;">
                                                    <i class="fas fa-chair"></i> ${s.train.totalSeats - s.bookedSeats} /
                                                    ${s.train.totalSeats} Seats
                                                </div>
                                            </div>
                                        </div>

                                        <!-- Route Info -->
                                        <div
                                            style="display: flex; align-items: center; justify-content: space-between; text-align: center;">
                                            <div>
                                                <div
                                                    style="font-size: 1.25rem; font-weight: 700; color: var(--text-color);">
                                                    <fmt:formatDate value="${s.departureTime}" pattern="HH:mm" />
                                                </div>
                                                <div
                                                    style="color: var(--text-muted); font-size: 0.85rem; margin-top: 0.25rem; margin-bottom: 0.25rem;">
                                                    <i class="far fa-calendar-alt"></i>
                                                    <fmt:formatDate value="${s.departureTime}" pattern="dd/MM/yyyy" />
                                                </div>
                                                <div style="color: var(--text-muted); font-size: 0.9rem;">
                                                    ${s.departureStation.name}</div>
                                            </div>
                                            <div style="flex: 1; padding: 0 1.5rem; position: relative;">
                                                <div
                                                    style="border-top: 2px dashed var(--border-color); width: 100%; position: absolute; top: 50%; left: 0;">
                                                </div>
                                                <i class="fas fa-train"
                                                    style="position: relative; background: white; padding: 0 0.5rem; color: var(--primary-color);"></i>
                                                <div
                                                    style="margin-top: 0.5rem; font-size: 0.8rem; color: var(--text-muted);">
                                                    Direct</div>
                                            </div>
                                            <div>
                                                <div
                                                    style="font-size: 1.25rem; font-weight: 700; color: var(--text-color);">
                                                    <fmt:formatDate value="${s.arrivalTime}" pattern="HH:mm" />
                                                </div>
                                                <div
                                                    style="color: var(--text-muted); font-size: 0.85rem; margin-top: 0.25rem; margin-bottom: 0.25rem;">
                                                    <i class="far fa-calendar-alt"></i>
                                                    <fmt:formatDate value="${s.arrivalTime}" pattern="dd/MM/yyyy" />
                                                </div>
                                                <div style="color: var(--text-muted); font-size: 0.9rem;">
                                                    ${s.arrivalStation.name}</div>
                                            </div>
                                        </div>

                                        <!-- Price & Action -->
                                        <div style="text-align: right;">
                                            <div
                                                style="font-size: 1.5rem; font-weight: 800; color: var(--primary-color); margin-bottom: 0.5rem;">
                                                <fmt:formatNumber value="${s.price}" type="currency"
                                                    maxFractionDigits="0" currencySymbol="₫" />
                                            </div>
                                            <button type="button" class="btn btn-primary" style="width: 100%;"
                                                data-id="${s.id}" data-code="${s.train.code}"
                                                data-dep-station="${s.departureStation.name}"
                                                data-arr-station="${s.arrivalStation.name}"
                                                data-time='<fmt:formatDate value="${s.departureTime}" pattern="HH:mm" />'
                                                data-date='<fmt:formatDate value="${s.departureTime}" pattern="dd-MM-yyyy" />'
                                                data-price="${s.price}" onclick="openBookingModal(this)">
                                                Book Now
                                            </button>
                                        </div>
                                    </div>
                                </c:forEach>
                            </div>
                        </c:if>
                    </div>

                    <div
                        style="margin-top: 5rem; background: white; padding: 3rem 1rem; text-align: center; color: var(--text-muted);">
                        <p>&copy; 2025 NextGen Rails. All rights reserved.</p>
                    </div>

                    <!-- Booking Modal -->
                    <div id="booking-modal-overlay" class="modal-overlay"
                        style="display: none; position: fixed; top: 0; left: 0; width: 100%; height: 100%; z-index: 1000; align-items: center; justify-content: center;">
                        <div class="modal"
                            style="width: 95%; max-width: 1200px; background: #fff; border-radius: 16px; box-shadow: 0 25px 50px -12px rgba(0, 0, 0, 0.25); display: flex; flex-direction: column; max-height: 95vh; overflow: hidden; animation: modalSlideIn 0.3s ease-out;">

                            <form id="booking-form" action="${pageContext.request.contextPath}/bookings" method="post"
                                style="display: flex; flex-direction: column; height: 100%;">
                                <input type="hidden" id="form-schedule-id" name="scheduleId" value="">

                                <!-- Header -->
                                <div class="modal-header"
                                    style="padding: 1.25rem 2rem; background: linear-gradient(135deg, var(--primary-color), var(--secondary-color)); color: white; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 4px 6px -1px rgba(0, 0, 0, 0.1); z-index: 10;">
                                    <div>
                                        <h3 id="modal-title" style="margin:0; font-size:1.5rem; font-weight: 700;">
                                            Booking Confirmation</h3>
                                        <div
                                            style="display: flex; gap: 1rem; margin-top: 0.25rem; opacity: 0.9; font-size: 0.95rem;">
                                            <span class="modal-route-display"><i class="fas fa-route"></i> Route
                                                Info</span>
                                            <span>•</span>
                                            <span class="modal-time-display"><i class="far fa-clock"></i> Time
                                                Info</span>
                                        </div>
                                    </div>
                                    <button type="button" onclick="closeBookingModal()"
                                        style="background:rgba(255,255,255,0.2); border:none; color:white; width: 36px; height: 36px; border-radius: 50%; display: flex; align-items: center; justify-content: center; cursor:pointer; font-size: 1.2rem; transition: background 0.2s;">
                                        <i class="fas fa-times"></i>
                                    </button>
                                </div>

                                <!-- Scrollable Body -->
                                <div class="modal-body"
                                    style="padding: 2rem; overflow-y: auto; flex: 1; background: #f8fafc;">
                                    <div
                                        style="display: grid; grid-template-columns: 1.2fr 0.8fr; gap: 2rem; height: 100%;">

                                        <!-- LEFT COLUMN: Inputs -->
                                        <div style="display: flex; flex-direction: column; gap: 1.5rem;">

                                            <!-- Passenger Info Section -->
                                            <div
                                                style="background: white; padding: 1.5rem; border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); border: 1px solid #e2e8f0;">
                                                <h4
                                                    style="margin-top: 0; margin-bottom: 1.25rem; color: var(--text-color); font-size: 1.1rem; display: flex; align-items: center; gap: 0.5rem;">
                                                    <div
                                                        style="width: 32px; height: 32px; background: #e0f2fe; color: var(--primary-color); border-radius: 8px; display: flex; align-items: center; justify-content: center;">
                                                        <i class="fas fa-user"></i>
                                                    </div>
                                                    Passenger Details
                                                </h4>
                                                <div style="display: grid; grid-template-columns: 1fr 1fr; gap: 2rem;">
                                                    <div class="form-group" style="margin:0;">
                                                        <label
                                                            style="display: block; font-size: 0.875rem; font-weight: 500; color: #64748b; margin-bottom: 0.5rem;">Full
                                                            Name</label>
                                                        <input type="text" name="fullName" required
                                                            placeholder="Enter your full name"
                                                            style="width: 100%; padding: 0.75rem; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 0.95rem; transition: border-color 0.2s;">
                                                    </div>
                                                    <div class="form-group" style="margin:0;">
                                                        <label
                                                            style="display: block; font-size: 0.875rem; font-weight: 500; color: #64748b; margin-bottom: 0.5rem;">ID
                                                            Card/Passport</label>
                                                        <input type="number" name="idCard" required
                                                            placeholder="Enter 9-digit ID number"
                                                            style="width: 100%; padding: 0.75rem; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 0.95rem;">
                                                        <small
                                                            style="color: #94a3b8; font-size: 0.8rem; margin-top: 0.25rem; display: block;">Required
                                                            for passenger verification.</small>
                                                    </div>
                                                    <div class="form-group" style="margin:0;">
                                                        <label
                                                            style="display: block; font-size: 0.875rem; font-weight: 500; color: #64748b; margin-bottom: 0.5rem;">Phone
                                                            Number</label>
                                                        <input type="tel" name="phone" required
                                                            placeholder="Enter 10-digit phone number"
                                                            style="width: 100%; padding: 0.75rem; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 0.95rem;">
                                                        <small
                                                            style="color: #94a3b8; font-size: 0.8rem; margin-top: 0.25rem; display: block;">For
                                                            booking updates and contact.</small>
                                                    </div>
                                                    <div class="form-group" style="margin:0;">
                                                        <label
                                                            style="display: block; font-size: 0.875rem; font-weight: 500; color: #64748b; margin-bottom: 0.5rem;">Email
                                                            Address</label>
                                                        <input type="email" name="email" required
                                                            placeholder="Enter your email address"
                                                            style="width: 100%; padding: 0.75rem; border: 1px solid #cbd5e1; border-radius: 8px; font-size: 0.95rem;">
                                                        <small
                                                            style="color: #94a3b8; font-size: 0.8rem; margin-top: 0.25rem; display: block;">Your
                                                            ticket will be sent to this email.</small>
                                                    </div>
                                                </div>
                                            </div>

                                            <!-- Ticket Details Section -->
                                            <div
                                                style="background: white; padding: 1.5rem; border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); border: 1px solid #e2e8f0;">
                                                <h4
                                                    style="margin-top: 0; margin-bottom: 1.25rem; color: var(--text-color); font-size: 1.1rem; display: flex; align-items: center; gap: 0.5rem;">
                                                    <div
                                                        style="width: 32px; height: 32px; background: #dcfce7; color: #166534; border-radius: 8px; display: flex; align-items: center; justify-content: center;">
                                                        <i class="fas fa-ticket-alt"></i>
                                                    </div>
                                                    Booking Options
                                                </h4>
                                                <div
                                                    style="display: grid; grid-template-columns: 1fr 2fr; gap: 1.5rem;">
                                                    <div class="form-group" style="margin:0;">
                                                        <label
                                                            style="display: block; font-size: 0.875rem; font-weight: 500; color: #64748b; margin-bottom: 0.5rem;">Tickets</label>
                                                        <div style="display:flex; align-items:center;">
                                                            <button type="button" onclick="adjustQuantity(-1)"
                                                                style="width:36px; height:42px; border:1px solid #cbd5e1; background:#f1f5f9; border-radius:8px 0 0 8px; cursor:pointer; color: #64748b; transition: background 0.2s;"><i
                                                                    class="fas fa-minus"
                                                                    style="font-size: 0.8rem;"></i></button>
                                                            <input type="number" id="ticket-quantity" name="quantity"
                                                                value="1" min="1" max="10"
                                                                style="width: 60px; height: 42px; border-top: 1px solid #cbd5e1; border-bottom: 1px solid #cbd5e1; border-left:none; border-right:none; border-radius:0; text-align:center; font-weight: 600; font-size: 1rem; color: var(--text-color);"
                                                                onchange="updateTotal()">
                                                            <button type="button" onclick="adjustQuantity(1)"
                                                                style="width:36px; height:42px; border:1px solid #cbd5e1; background:#f1f5f9; border-radius:0 8px 8px 0; cursor:pointer; color: #64748b; transition: background 0.2s;"><i
                                                                    class="fas fa-plus"
                                                                    style="font-size: 0.8rem;"></i></button>
                                                        </div>
                                                    </div>
                                                    <div class="form-group" style="margin:0;">
                                                        <label
                                                            style="display: block; font-size: 0.875rem; font-weight: 500; color: #64748b; margin-bottom: 0.5rem;">Notes</label>
                                                        <textarea name="notes" rows="1"
                                                            placeholder="Special requests..."
                                                            style="width:100%; height: 42px; padding:0.6rem; border:1px solid #cbd5e1; border-radius:8px; resize: none; font-family: inherit; font-size: 0.95rem;"></textarea>
                                                    </div>
                                                </div>
                                            </div>
                                        </div>

                                        <!-- RIGHT COLUMN: Payment & Payment Method -->
                                        <div style="display: flex; flex-direction: column; gap: 1.5rem;">

                                            <!-- Payment Method -->
                                            <div
                                                style="background: white; padding: 1.5rem; border-radius: 12px; box-shadow: 0 1px 3px rgba(0,0,0,0.1); border: 1px solid #e2e8f0; height: 100%;">
                                                <h4
                                                    style="margin-top: 0; margin-bottom: 1.25rem; color: var(--text-color); font-size: 1.1rem; display: flex; align-items: center; gap: 0.5rem;">
                                                    <div
                                                        style="width: 32px; height: 32px; background: #fff7ed; color: #c2410c; border-radius: 8px; display: flex; align-items: center; justify-content: center;">
                                                        <i class="fas fa-wallet"></i>
                                                    </div>
                                                    Payment Method
                                                </h4>
                                                <div style="display: flex; flex-direction: column; gap: 1rem;">
                                                    <label class="payment-option"
                                                        style="display:flex; align-items:center; gap:1rem; padding:1rem; border:2px solid #e2e8f0; border-radius:12px; cursor:pointer; transition: all 0.2s; position: relative; overflow: hidden;">
                                                        <input type="radio" name="paymentInfo" value="momo" required
                                                            style="width: 1.2rem; height: 1.2rem; accent-color: var(--primary-color);">
                                                        <div style="display: flex; flex-direction: column;">
                                                            <span
                                                                style="font-weight: 600; color: var(--text-color);">E-Wallet</span>
                                                            <span style="font-size: 0.85rem; color: #64748b;">Momo /
                                                                ZaloPay</span>
                                                        </div>
                                                        <i class="fas fa-mobile-alt"
                                                            style="margin-left: auto; color: #94a3b8; font-size: 1.25rem;"></i>
                                                    </label>

                                                    <label class="payment-option"
                                                        style="display:flex; align-items:center; gap:1rem; padding:1rem; border:2px solid #e2e8f0; border-radius:12px; cursor:pointer; transition: all 0.2s;">
                                                        <input type="radio" name="paymentInfo" value="card"
                                                            style="width: 1.2rem; height: 1.2rem; accent-color: var(--primary-color);">
                                                        <div style="display: flex; flex-direction: column;">
                                                            <span
                                                                style="font-weight: 600; color: var(--text-color);">Credit
                                                                Card</span>
                                                            <span style="font-size: 0.85rem; color: #64748b;">Visa /
                                                                Master</span>
                                                        </div>
                                                        <i class="fas fa-credit-card"
                                                            style="margin-left: auto; color: #94a3b8; font-size: 1.25rem;"></i>
                                                    </label>

                                                    <label class="payment-option"
                                                        style="display:flex; align-items:center; gap:1rem; padding:1rem; border:2px solid #e2e8f0; border-radius:12px; cursor:pointer; transition: all 0.2s;">
                                                        <input type="radio" name="paymentInfo" value="pay_later"
                                                            style="width: 1.2rem; height: 1.2rem; accent-color: var(--primary-color);">
                                                        <div style="display: flex; flex-direction: column;">
                                                            <span
                                                                style="font-weight: 600; color: var(--text-color);">Pay
                                                                Later</span>
                                                            <span style="font-size: 0.85rem; color: #64748b;">Hold for
                                                                24h</span>
                                                        </div>
                                                        <i class="fas fa-clock"
                                                            style="margin-left: auto; color: #94a3b8; font-size: 1.25rem;"></i>
                                                    </label>
                                                </div>
                                            </div>
                                        </div>
                                    </div>
                                </div>
                                <!-- Footer (Fixed) -->
                                <div class="modal-footer"
                                    style="padding: 1.5rem 2rem; background: white; border-top: 1px solid #e2e8f0; display: flex; justify-content: space-between; align-items: center; box-shadow: 0 -4px 6px -1px rgba(0,0,0,0.05); z-index: 10;">
                                    <div style="display: flex; flex-direction: column;">
                                        <span style="font-size: 0.9rem; color: #64748b; font-weight: 500;">Total
                                            Payment</span>
                                        <span id="modal-total"
                                            style="font-size: 2rem; font-weight: 800; color: var(--primary-color); line-height: 1.2;">0
                                            ₫</span>
                                        <span id="modal-base-price-display"
                                            style="font-size: 0.85rem; color: #94a3b8;">Base: <span id="modal-price">0
                                                ₫</span> / ticket</span>
                                    </div>

                                    <div style="display: flex; gap: 1rem;">
                                        <button type="button" onclick="closeBookingModal()"
                                            style="padding: 0.8rem 1.5rem; background: white; border: 1px solid #cbd5e1; color: #64748b; border-radius: 10px; font-weight: 600; cursor: pointer; transition: all 0.2s;">
                                            Cancel
                                        </button>
                                        <button type="button" id="btn-pay-now" onclick="handlePayment()"
                                            style="padding: 0.8rem 2rem; background: var(--primary-color); border: none; color: white; border-radius: 10px; font-weight: 600; cursor: pointer; display: flex; align-items: center; gap: 0.5rem; shadow: 0 4px 6px rgba(var(--primary-rgb), 0.3); transition: all 0.2s;">
                                            <span>Confirm Booking</span>
                                            <i class="fas fa-arrow-right"></i>
                                        </button>
                                    </div>
                                </div>

                            </form>
                        </div>
                    </div>

                    <script>
                        const IS_LOGGED_IN = <c:out value="${not empty sessionScope.user}" default="false" />;
                        const LOGIN_URL = "${pageContext.request.contextPath}/login";
                    </script>
                    <script src="${pageContext.request.contextPath}/assets/js/booking.js"></script>
            </body>

            </html>