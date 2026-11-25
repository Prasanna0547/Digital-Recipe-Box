/**
 * Digital Recipe Box - Client-side interactive script
 */

document.addEventListener('DOMContentLoaded', function () {
    // 1. Toast auto dismissal
    const alerts = document.querySelectorAll('.alert-dismissible');
    alerts.forEach(function (alert) {
        setTimeout(function () {
            const bsAlert = new bootstrap.Alert(alert);
            bsAlert.close();
        }, 5000);
    });

    // 2. Interactive Ingredient Tag Click for Recommendation Engine
    const tagButtons = document.querySelectorAll('.ingredient-tag-btn');
    const ingredientInput = document.getElementById('ingredientsInput');

    if (tagButtons && ingredientInput) {
        tagButtons.forEach(function (btn) {
            btn.addEventListener('click', function () {
                const tag = this.dataset.tag;
                let currentVal = ingredientInput.value.trim();
                if (currentVal.length > 0) {
                    // avoid duplicate tags
                    const parts = currentVal.split(',').map(s => s.trim().toLowerCase());
                    if (!parts.includes(tag.toLowerCase())) {
                        ingredientInput.value = currentVal + ', ' + tag;
                    }
                } else {
                    ingredientInput.value = tag;
                }
            });
        });
    }

    // 3. Interactive Shopping List Checkbox Handler
    const shoppingCheckboxes = document.querySelectorAll('.shopping-item-checkbox');
    shoppingCheckboxes.forEach(function (chk) {
        chk.addEventListener('change', function () {
            const form = this.closest('form');
            if (form) {
                form.submit();
            }
        });
    });
});
