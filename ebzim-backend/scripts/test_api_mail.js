async function triggerForgotPassword() {
  try {
    const testEmail = 'matique2026ai@gmail.com'; 

    // 1. Register to make sure the user exists!
    console.log("Registering user:", testEmail);
    const regRes = await fetch('http://localhost:3000/api/v1/auth/register', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email: testEmail, password: 'securePassword456', profile: { firstName: 'Diagnostic' } })
    });
    console.log('Register Status:', regRes.status);
    
    // 2. Request Forgot Password
    console.log("Requesting Forgot Password API for:", testEmail);
    const fpRes = await fetch('http://localhost:3000/api/v1/auth/forgot-password', {
      method: 'POST',
      headers: { 'Content-Type': 'application/json' },
      body: JSON.stringify({ email: testEmail })
    });
    const fpStatus = fpRes.status;
    const fpBody = await fpRes.json();
    
    console.log('Forgot Password Status:', fpStatus);
    console.log('Forgot Password Body:', fpBody);

  } catch (err) {
    console.error('Test Failed:', err);
  }
}

triggerForgotPassword();
