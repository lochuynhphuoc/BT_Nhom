// Toast Notification System
const Toast = {
    container: null,

    init() {
        this.container = document.createElement('div');
        this.container.className = 'toast-container';
        document.body.appendChild(this.container);
    },

    show(message, type = 'info') {
        if (!this.container) this.init();

        const toast = document.createElement('div');
        toast.className = `toast ${type}`;

        let icon = 'info-circle';
        if (type === 'success') icon = 'check-circle';
        if (type === 'error') icon = 'exclamation-circle';

        toast.innerHTML = `
            <div class="toast-icon"><i class="fas fa-${icon}"></i></div>
            <div class="toast-message">${message}</div>
        `;

        this.container.appendChild(toast);

        // Auto remove
        setTimeout(() => {
            toast.classList.add('hiding');
            toast.addEventListener('animationend', () => {
                toast.remove();
            });
        }, 5000); // 5 seconds
    }
};

// Check for flash messages from backend (embedded in HTML usually)
document.addEventListener('DOMContentLoaded', () => {
    // If there's a hidden input with flash-message class
    const flashMsg = document.getElementById('flash-message');
    const flashType = document.getElementById('flash-type');

    if (flashMsg && flashMsg.value) {
        Toast.show(flashMsg.value, flashType ? flashType.value : 'info');
    }
});
