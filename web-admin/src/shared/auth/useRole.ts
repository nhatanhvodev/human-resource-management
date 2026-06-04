import { useMemo } from 'react';

type Role = 'ADMIN' | 'EMPLOYEE';

export function useRole(): Role {
  return useMemo(() => {
    try {
      const token = localStorage.getItem('token');
      if (!token) return 'EMPLOYEE';
      const payload = JSON.parse(atob(token.split('.')[1]));
      return payload?.role === 'ADMIN' ? 'ADMIN' : 'EMPLOYEE';
    } catch {
      return 'EMPLOYEE';
    }
  }, []);
}
