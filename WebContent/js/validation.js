
function isValidEmail(email) {
    return /^[\w.%+\-]+@[\w.\-]+\.[a-zA-Z]{2,}$/.test(email.trim());
}

function isValidPhone(phone) {
    return /^\d{10}$/.test(phone.trim());
}

function validateStudentForm(formId) {
    var form   = document.getElementById(formId);
    if (!form) return true;

    var errors = [];

    var get = function(name) {
        var el = form.querySelector('[name="' + name + '"]');
        return el ? el.value.trim() : '';
    };

    if (!get('studentId'))   errors.push('Student ID is required.');
    if (!get('name'))        errors.push('Full Name is required.');
    if (!get('email'))       errors.push('Email is required.');
    else if (!isValidEmail(get('email')))  errors.push('Please enter a valid email address.');
    if (!get('phone'))       errors.push('Phone number is required.');
    else if (!isValidPhone(get('phone')))  errors.push('Phone must be exactly 10 digits.');
    if (!get('department'))  errors.push('Department is required.');
    if (!get('semester'))    errors.push('Semester is required.');
    if (!get('gender'))      errors.push('Gender is required.');

    var sem = parseInt(get('semester'), 10);
    if (get('semester') && (isNaN(sem) || sem < 1 || sem > 8)) {
        errors.push('Semester must be a number between 1 and 8.');
    }

    if (errors.length > 0) {
        showClientError(form, errors.join(' '));
        return false;
    }

    clearClientError(form);
    return true;
}

function confirmDelete(studentName) {
    return window.confirm('Delete student "' + studentName + '"?\nThis action cannot be undone.');
}

function showClientError(form, message) {
    var box = form.querySelector('.client-error');
    if (!box) {
        box = document.createElement('div');
        box.className = 'alert alert-error client-error';
        form.insertBefore(box, form.firstChild);
    }
    box.textContent = message;
    box.style.display = 'block';
    box.scrollIntoView({ behavior: 'smooth', block: 'nearest' });
}

function clearClientError(form) {
    var box = form.querySelector('.client-error');
    if (box) box.style.display = 'none';
}

document.addEventListener('DOMContentLoaded', function () {
    var flash = document.querySelector('.alert-success');
    if (flash) {
        setTimeout(function () {
            flash.style.transition = 'opacity 0.4s';
            flash.style.opacity    = '0';
            setTimeout(function () { flash.style.display = 'none'; }, 400);
        }, 5000);
    }
});
