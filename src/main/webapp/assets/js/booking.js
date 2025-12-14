/**
 * Booking Modal Logic
 */

let currentBasePrice = 0;

function openBookingModal(button) {
    if (typeof IS_LOGGED_IN !== 'undefined' && !IS_LOGGED_IN) {
        if (typeof LOGIN_URL !== 'undefined') {
            window.location.href = LOGIN_URL;
        } else {
            window.location.href = 'login';
        }
        return;
    }
    // 1. Get data from button attributes
    const scheduleId = button.getAttribute('data-id');
    const trainCode = button.getAttribute('data-code');
    const depStation = button.getAttribute('data-dep-station');
    const arrStation = button.getAttribute('data-arr-station');
    const time = button.getAttribute('data-time');
    const date = button.getAttribute('data-date');
    const price = parseFloat(button.getAttribute('data-price'));

    // 2. Populate Modal UI
    document.getElementById('modal-title').innerText = `Booking Confirmation - ${trainCode}`;

    // Update all elements with these classes (Header)
    document.querySelectorAll('.modal-route-display').forEach(el => el.innerText = `${depStation} ➝ ${arrStation}`);
    document.querySelectorAll('.modal-time-display').forEach(el => el.innerText = `${time} - ${date}`);

    // Format price
    const formattedPrice = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND', maximumFractionDigits: 0 }).format(price);
    // Update ID modal-price (Footer)
    const priceEl = document.getElementById('modal-price');
    if (priceEl) priceEl.innerText = formattedPrice;

    // 3. Set Hidden Inputs and Internal State
    document.getElementById('form-schedule-id').value = scheduleId;
    currentBasePrice = price;

    // Reset Form
    document.getElementById('ticket-quantity').value = 1;
    document.querySelector('textarea[name="notes"]').value = '';

    // Clear validation styles
    document.querySelectorAll('.error-input').forEach(el => el.classList.remove('error-input'));

    // Update Total
    updateTotal();

    // 4. Show Modal
    const modal = document.getElementById('booking-modal-overlay');
    modal.style.display = 'flex';
    // Small timeout to allow display:flex to apply before adding class for potential transitions
    setTimeout(() => {
        modal.classList.add('active');
    }, 10);
}

function closeBookingModal() {
    const modal = document.getElementById('booking-modal-overlay');
    modal.classList.remove('active');
    setTimeout(() => {
        modal.style.display = 'none';
    }, 300); // Match CSS transition duration if any
}

function adjustQuantity(delta) {
    const input = document.getElementById('ticket-quantity');
    let newValue = parseInt(input.value) + delta;
    if (newValue < 1) newValue = 1;
    if (newValue > 10) newValue = 10; // Max limit
    input.value = newValue;
    updateTotal();
}

function updateTotal() {
    const quantity = parseInt(document.getElementById('ticket-quantity').value) || 1;
    const total = currentBasePrice * quantity;
    const formattedTotal = new Intl.NumberFormat('vi-VN', { style: 'currency', currency: 'VND', maximumFractionDigits: 0 }).format(total);
    document.getElementById('modal-total').innerText = formattedTotal;
}

function handlePayment() {
    // Validation
    const form = document.getElementById('booking-form');
    let isValid = true;

    // Required fields
    // 1. Full Name
    const nameInput = form.querySelector('[name="fullName"]');
    if (!nameInput.value.trim()) {
        nameInput.classList.add('error-input');
        isValid = false;
    } else {
        nameInput.classList.remove('error-input');
    }

    // 2. ID Card (Exactly 9 digits)
    const idInput = form.querySelector('[name="idCard"]');
    if (!idInput.value.trim() || !/^\d{9}$/.test(idInput.value.trim())) {
        idInput.classList.add('error-input');
        isValid = false;
    } else {
        idInput.classList.remove('error-input');
    }

    // 3. Phone (Exactly 10 digits)
    const phoneInput = form.querySelector('[name="phone"]');
    if (!phoneInput.value.trim() || !/^\d{10}$/.test(phoneInput.value.trim())) {
        phoneInput.classList.add('error-input');
        isValid = false;
    } else {
        phoneInput.classList.remove('error-input');
    }

    // 4. Email (Simple regex)
    const emailInput = form.querySelector('[name="email"]');
    const emailRegex = /^[^\s@]+@[^\s@]+\.[^\s@]+$/;
    if (!emailInput.value.trim() || !emailRegex.test(emailInput.value.trim())) {
        emailInput.classList.add('error-input');
        isValid = false;
    } else {
        emailInput.classList.remove('error-input');
    }

    // Payment Method Validation
    const paymentSelected = form.querySelector('input[name="paymentInfo"]:checked');
    if (!paymentSelected) {
        // Use Toast instead of alert
        if (typeof Toast !== 'undefined') {
            Toast.show("Please select a payment method.", "error");
        } else {
            alert("Please select a payment method.");
        }
        isValid = false;
    }

    if (!isValid) {
        if (typeof Toast !== 'undefined') {
            Toast.show("Please fill in all required fields correctly.", "error");
        } else {
            alert("Please fill in all required fields correctly.");
        }
        return;
    }

    // Prepare for submission
    const btn = document.getElementById('btn-pay-now');
    const originalText = btn.innerHTML;

    btn.innerHTML = '<i class="fas fa-spinner fa-spin"></i> Processing...';
    btn.disabled = true;
    btn.classList.add('loading');

    // Simulate network delay if needed, or submit directly
    setTimeout(() => {
        form.submit();
    }, 1500);
}

// Close modal when clicking outside
window.onclick = function (event) {
    const modal = document.getElementById('booking-modal-overlay');
    if (event.target == modal) {
        closeBookingModal();
    }
}
