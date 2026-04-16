/* ============================================
   WealthTrack — Main JavaScript
   Chart.js initialization, form validation, 
   and interactive UI logic
   ============================================ */

// ── Portfolio Performance Chart (Dashboard) ──
function initPerformanceChart() {
    const canvas = document.getElementById('performanceChart');
    if (!canvas) return;

    const ctx = canvas.getContext('2d');
    const gradient = ctx.createLinearGradient(0, 0, 0, 280);
    gradient.addColorStop(0, 'rgba(37, 99, 235, 0.15)');
    gradient.addColorStop(1, 'rgba(37, 99, 235, 0.01)');

    new Chart(ctx, {
        type: 'line',
        data: {
            labels: ['Jan', 'Feb', 'Mar', 'Apr', 'May', 'Jun', 'Jul', 'Aug'],
            datasets: [{
                label: 'Portfolio Value',
                data: [420000, 480000, 510000, 490000, 530000, 560000, 620000, 780000],
                borderColor: '#2563EB',
                backgroundColor: gradient,
                borderWidth: 2.5,
                fill: true,
                tension: 0.4,
                pointRadius: 0,
                pointHoverRadius: 6,
                pointHoverBackgroundColor: '#2563EB',
                pointHoverBorderColor: '#fff',
                pointHoverBorderWidth: 3
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            interaction: { intersect: false, mode: 'index' },
            plugins: {
                legend: { display: false },
                tooltip: {
                    backgroundColor: '#0F172A',
                    titleColor: '#94A3B8',
                    bodyColor: '#fff',
                    bodyFont: { size: 14, weight: '600' },
                    padding: 12,
                    cornerRadius: 8,
                    displayColors: false,
                    callbacks: {
                        label: function (ctx) { return '$' + ctx.parsed.y.toLocaleString(); }
                    }
                }
            },
            scales: {
                x: {
                    grid: { display: false },
                    ticks: { color: '#94A3B8', font: { size: 12 } },
                    border: { display: false }
                },
                y: {
                    grid: { color: '#F1F5F9', drawBorder: false },
                    ticks: {
                        color: '#94A3B8',
                        font: { size: 12 },
                        callback: function (val) {
                            if (val >= 1000000) return (val / 1000000).toFixed(1) + 'M';
                            if (val >= 1000) return (val / 1000) + 'K';
                            return val;
                        }
                    },
                    border: { display: false }
                }
            }
        }
    });
}

// ── Asset Detail Chart ──
function initAssetChart() {
    const canvas = document.getElementById('assetChart');
    if (!canvas) return;

    const ctx = canvas.getContext('2d');
    const gradient = ctx.createLinearGradient(0, 0, 0, 280);
    gradient.addColorStop(0, 'rgba(37, 99, 235, 0.12)');
    gradient.addColorStop(1, 'rgba(37, 99, 235, 0.01)');

    // Generate sample price data
    const labels = [];
    const data = [];
    const basePrice = 162;
    const days = 30;

    for (let i = 0; i < days; i++) {
        const date = new Date();
        date.setDate(date.getDate() - (days - i));
        labels.push(date.toLocaleDateString('en-US', { month: 'short', day: 'numeric' }));
        const variation = Math.sin(i * 0.3) * 5 + Math.random() * 4 - 2;
        data.push(basePrice + (i * 0.4) + variation);
    }

    new Chart(ctx, {
        type: 'line',
        data: {
            labels: labels,
            datasets: [{
                label: 'Price',
                data: data,
                borderColor: '#2563EB',
                backgroundColor: gradient,
                borderWidth: 2,
                fill: true,
                tension: 0.3,
                pointRadius: 0,
                pointHoverRadius: 5,
                pointHoverBackgroundColor: '#2563EB',
                pointHoverBorderColor: '#fff',
                pointHoverBorderWidth: 2
            }]
        },
        options: {
            responsive: true,
            maintainAspectRatio: false,
            interaction: { intersect: false, mode: 'index' },
            plugins: {
                legend: { display: false },
                tooltip: {
                    backgroundColor: '#0F172A',
                    bodyFont: { size: 13, weight: '600' },
                    padding: 10,
                    cornerRadius: 8,
                    displayColors: false,
                    callbacks: {
                        label: function (ctx) { return '$' + ctx.parsed.y.toFixed(2); }
                    }
                }
            },
            scales: {
                x: {
                    grid: { display: false },
                    ticks: {
                        color: '#94A3B8',
                        font: { size: 11 },
                        maxTicksLimit: 6
                    },
                    border: { display: false }
                },
                y: {
                    grid: { color: '#F1F5F9', drawBorder: false },
                    ticks: {
                        color: '#94A3B8',
                        font: { size: 11 },
                        callback: function (val) { return '$' + val.toFixed(0); }
                    },
                    border: { display: false }
                }
            }
        }
    });
}

// ── Form Validation ──
document.addEventListener('DOMContentLoaded', function () {
    // Login form validation
    const loginForm = document.getElementById('loginForm');
    if (loginForm) {
        loginForm.addEventListener('submit', function (e) {
            const email = document.getElementById('email').value.trim();
            const password = document.getElementById('password').value;
            if (!email || !password) {
                e.preventDefault();
                showFormError('Please fill in all fields.');
            }
        });
    }

    // Register form validation
    const registerForm = document.getElementById('registerForm');
    if (registerForm) {
        registerForm.addEventListener('submit', function (e) {
            const password = document.getElementById('password').value;
            const confirm = document.getElementById('confirmPassword').value;
            if (password !== confirm) {
                e.preventDefault();
                showFormError('Passwords do not match.');
            }
            if (password.length < 6) {
                e.preventDefault();
                showFormError('Password must be at least 6 characters.');
            }
        });
    }

    // Add smooth card animations
    const cards = document.querySelectorAll('.summary-card, .card');
    cards.forEach((card, i) => {
        card.style.opacity = '0';
        card.style.transform = 'translateY(12px)';
        setTimeout(() => {
            card.style.transition = 'opacity 0.4s ease, transform 0.4s ease';
            card.style.opacity = '1';
            card.style.transform = 'translateY(0)';
        }, 60 * i);
    });
});

function showFormError(msg) {
    const existing = document.querySelector('.alert-error');
    if (existing) existing.remove();

    const alert = document.createElement('div');
    alert.className = 'alert alert-error';
    alert.innerHTML = '<i class="fas fa-exclamation-circle"></i> ' + msg;

    const form = document.querySelector('form');
    if (form) form.insertBefore(alert, form.firstChild);

    setTimeout(() => { alert.style.opacity = '0'; setTimeout(() => alert.remove(), 300); }, 4000);
}

// ── Number Formatting Helper ──
function formatCurrency(num) {
    return '$' + parseFloat(num).toLocaleString('en-US', { minimumFractionDigits: 2, maximumFractionDigits: 2 });
}
