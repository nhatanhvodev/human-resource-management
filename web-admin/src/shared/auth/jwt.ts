export function getEmployeeId(): string {
  try {
    const token = localStorage.getItem('token');
    if (!token) return '';
    const payload = JSON.parse(atob(token.split('.')[1]));
    return payload?.sub ?? '';
  } catch {
    return '';
  }
}

export function getToken(): string {
  return localStorage.getItem('token') ?? '';
}
