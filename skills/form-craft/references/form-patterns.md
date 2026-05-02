# Form Patterns — Copy-Paste Ready Code

## Floating Labels (CSS + HTML)

```css
.form-group {
  position: relative;
  margin-bottom: 24px;
}
.form-input {
  width: 100%;
  padding: 16px 14px 6px;
  font-size: 1rem;
  border: 2px solid #ddd;
  border-radius: 10px;
  outline: none;
  background: transparent;
  transition: border-color 0.3s ease;
  box-sizing: border-box;
}
.form-input:focus {
  border-color: var(--accent, #6366f1);
}
.form-label {
  position: absolute;
  left: 14px;
  top: 50%;
  transform: translateY(-50%);
  font-size: 1rem;
  color: #999;
  pointer-events: none;
  transition: all 0.2s ease;
}
.form-input:focus ~ .form-label,
.form-input:not(:placeholder-shown) ~ .form-label {
  top: 8px;
  transform: translateY(0);
  font-size: 0.72rem;
  color: var(--accent, #6366f1);
  font-weight: 600;
}
.form-input::placeholder { color: transparent; }
```

```html
<div class="form-group">
  <input class="form-input" type="text" id="name" placeholder=" " required>
  <label class="form-label" for="name">Full Name</label>
</div>
```

## Multi-Step Wizard JS

```js
class MultiStepForm {
  constructor(formEl) {
    this.form = formEl;
    this.steps = [...formEl.querySelectorAll('.form-step')];
    this.currentStep = 0;
    this.totalSteps = this.steps.length;
    this.progressBar = formEl.querySelector('.progress-fill');
    this.init();
  }
  init() {
    this.showStep(0);
    this.form.querySelectorAll('.btn-next').forEach(btn => {
      btn.addEventListener('click', () => this.next());
    });
    this.form.querySelectorAll('.btn-prev').forEach(btn => {
      btn.addEventListener('click', () => this.prev());
    });
  }
  showStep(index) {
    this.steps.forEach((step, i) => {
      step.style.display = i === index ? 'block' : 'none';
      if (i === index) {
        step.style.animation = 'slideIn 0.4s ease';
        const firstInput = step.querySelector('input, select, textarea');
        if (firstInput) setTimeout(() => firstInput.focus(), 100);
      }
    });
    this.currentStep = index;
    this.updateProgress();
  }
  next() {
    const currentStepEl = this.steps[this.currentStep];
    const inputs = currentStepEl.querySelectorAll('input, select, textarea');
    let valid = true;
    inputs.forEach(input => {
      if (!input.checkValidity()) {
        input.classList.add('error');
        valid = false;
        input.style.animation = 'shake 0.4s ease';
        setTimeout(() => input.style.animation = '', 400);
      }
    });
    if (valid && this.currentStep < this.totalSteps - 1) {
      this.showStep(this.currentStep + 1);
    }
  }
  prev() {
    if (this.currentStep > 0) this.showStep(this.currentStep - 1);
  }
  updateProgress() {
    const pct = ((this.currentStep + 1) / this.totalSteps) * 100;
    if (this.progressBar) {
      this.progressBar.style.width = `${pct}%`;
    }
  }
}
// Usage: new MultiStepForm(document.getElementById('myForm'));
```

## Typeform-Style Navigation

```js
class TypeformStyle {
  constructor(formEl) {
    this.form = formEl;
    this.questions = [...formEl.querySelectorAll('.tf-question')];
    this.current = 0;
    this.init();
  }
  init() {
    this.questions.forEach((q, i) => {
      q.style.cssText = `
        position: absolute; top: 0; left: 0; width: 100%; height: 100%;
        display: flex; flex-direction: column; justify-content: center;
        align-items: center; padding: 40px;
        opacity: ${i === 0 ? 1 : 0}; transform: translateY(${i === 0 ? 0 : 40}px);
        transition: opacity 0.5s ease, transform 0.5s ease;
        pointer-events: ${i === 0 ? 'auto' : 'none'};
      `;
    });
    document.addEventListener('keydown', (e) => {
      if (e.key === 'Enter') { e.preventDefault(); this.next(); }
      if (e.key === 'Escape') this.prev();
    });
    this.form.querySelectorAll('.tf-next').forEach(btn => {
      btn.addEventListener('click', () => this.next());
    });
  }
  goTo(index) {
    if (index < 0 || index >= this.questions.length) return;
    this.questions[this.current].style.opacity = '0';
    this.questions[this.current].style.transform = 'translateY(-40px)';
    this.questions[this.current].style.pointerEvents = 'none';
    this.current = index;
    this.questions[this.current].style.opacity = '1';
    this.questions[this.current].style.transform = 'translateY(0)';
    this.questions[this.current].style.pointerEvents = 'auto';
    const input = this.questions[this.current].querySelector('input, select, textarea');
    if (input) setTimeout(() => input.focus(), 300);
  }
  next() { this.goTo(this.current + 1); }
  prev() { this.goTo(this.current - 1); }
}
```

## Real-Time Validation Patterns

```js
const validators = {
  email: (v) => /^[^\s@]+@[^\s@]+\.[^\s@]+$/.test(v),
  phone: (v) => /^[\+]?[(]?[0-9]{3}[)]?[-\s\.]?[0-9]{3}[-\s\.]?[0-9]{4,6}$/.test(v),
  minLength: (min) => (v) => v.length >= min,
  maxLength: (max) => (v) => v.length <= max,
  required: (v) => v.trim().length > 0,
};

function initRealTimeValidation() {
  document.querySelectorAll('[data-validate]').forEach(input => {
    const rules = input.dataset.validate.split(',');
    const feedback = input.parentElement.querySelector('.validation-feedback');
    input.addEventListener('input', () => {
      const value = input.value;
      let valid = true;
      let message = '';
      rules.forEach(rule => {
        const [name, param] = rule.split(':');
        const fn = param ? validators[name]?.(param) : validators[name];
        if (fn && !fn(value)) {
          valid = false;
          message = input.dataset[`error${name.charAt(0).toUpperCase() + name.slice(1)}`] || 'Invalid';
        }
      });
      input.classList.toggle('valid', valid && value.length > 0);
      input.classList.toggle('error', !valid && value.length > 0);
      if (feedback) {
        feedback.textContent = !valid && value.length > 0 ? message : '';
        feedback.style.color = valid ? '#22c55e' : '#ef4444';
      }
    });
  });
}
```

```css
.form-input.valid { border-color: #22c55e; }
.form-input.error { border-color: #ef4444; }
.form-input.valid + .form-label { color: #22c55e; }
.form-input.error + .form-label { color: #ef4444; }
.validation-feedback {
  font-size: 0.8rem; margin-top: 4px; min-height: 20px;
  transition: all 0.2s ease;
}
```

## Success Animations

```css
/* Checkmark animation */
.success-checkmark {
  width: 80px; height: 80px; margin: 0 auto;
}
.success-checkmark svg { width: 100%; height: 100%; }
.checkmark-circle {
  stroke: #22c55e; stroke-width: 2; fill: none;
  stroke-dasharray: 166; stroke-dashoffset: 166;
  animation: stroke 0.6s cubic-bezier(0.65, 0, 0.45, 1) forwards;
}
.checkmark-check {
  stroke: #22c55e; stroke-width: 3; fill: none;
  stroke-dasharray: 48; stroke-dashoffset: 48;
  animation: stroke 0.3s cubic-bezier(0.65, 0, 0.45, 1) 0.4s forwards;
  stroke-linecap: round; stroke-linejoin: round;
}
@keyframes stroke {
  100% { stroke-dashoffset: 0; }
}
```

```html
<div class="success-checkmark">
  <svg viewBox="0 0 52 52">
    <circle class="checkmark-circle" cx="26" cy="26" r="25"/>
    <path class="checkmark-check" d="M14.1 27.2l7.1 7.2 16.7-16.8"/>
  </svg>
</div>
```

## Submit Button Spinner Transform

```js
function initSubmitButton(btn) {
  const originalText = btn.textContent;
  btn.addEventListener('click', async (e) => {
    e.preventDefault();
    btn.disabled = true;
    btn.innerHTML = '<span class="spinner"></span>';
    btn.style.minWidth = btn.offsetWidth + 'px';
    try {
      // Replace with actual submit logic
      await new Promise(r => setTimeout(r, 1500));
      btn.innerHTML = '<svg width="24" height="24" viewBox="0 0 24 24" fill="none" stroke="#fff" stroke-width="3"><path d="M5 13l4 4L19 7"/></svg>';
      btn.style.background = '#22c55e';
    } catch {
      btn.textContent = originalText;
      btn.disabled = false;
    }
  });
}
```

```css
.spinner {
  display: inline-block; width: 20px; height: 20px;
  border: 2.5px solid rgba(255,255,255,0.3);
  border-top-color: #fff; border-radius: 50%;
  animation: spin 0.6s linear infinite;
}
@keyframes spin { to { transform: rotate(360deg); } }
```

## Progress Bar

```css
.progress-bar {
  position: fixed; top: 0; left: 0; width: 100%;
  height: 4px; background: #eee; z-index: 1000;
}
.progress-fill {
  height: 100%; background: var(--accent, #6366f1);
  width: 0%; transition: width 0.4s cubic-bezier(0.23, 1, 0.32, 1);
  border-radius: 0 2px 2px 0;
}
```

## Step Dots Indicator

```css
.step-dots { display: flex; gap: 8px; justify-content: center; margin: 24px 0; }
.step-dot {
  width: 10px; height: 10px; border-radius: 50%;
  background: #ddd; transition: all 0.3s ease;
}
.step-dot.active { background: var(--accent, #6366f1); transform: scale(1.3); }
.step-dot.completed { background: #22c55e; }
```

## Shake Animation (Error)

```css
@keyframes shake {
  0%, 100% { transform: translateX(0); }
  20% { transform: translateX(-8px); }
  40% { transform: translateX(8px); }
  60% { transform: translateX(-6px); }
  80% { transform: translateX(6px); }
}
```

## Slide-In Step Transition

```css
@keyframes slideIn {
  from { opacity: 0; transform: translateX(30px); }
  to { opacity: 1; transform: translateX(0); }
}
@keyframes slideOut {
  from { opacity: 1; transform: translateX(0); }
  to { opacity: 0; transform: translateX(-30px); }
}
```

## Keyboard Navigation Handler

```js
function initKeyboardNav(form) {
  form.addEventListener('keydown', (e) => {
    const active = document.activeElement;
    if (e.key === 'Enter' && active.tagName !== 'TEXTAREA') {
      e.preventDefault();
      const nextBtn = active.closest('.form-step')?.querySelector('.btn-next');
      if (nextBtn) nextBtn.click();
    }
    if (e.key === 'Escape') {
      const prevBtn = active.closest('.form-step')?.querySelector('.btn-prev');
      if (prevBtn) prevBtn.click();
    }
    if (e.key === 'Tab') {
      const currentStep = document.querySelector('.form-step[style*="display: block"]');
      if (currentStep) {
        const focusable = currentStep.querySelectorAll('input, select, textarea, button');
        const first = focusable[0];
        const last = focusable[focusable.length - 1];
        if (e.shiftKey && active === first) { e.preventDefault(); last.focus(); }
        else if (!e.shiftKey && active === last) { e.preventDefault(); first.focus(); }
      }
    }
  });
}
```
