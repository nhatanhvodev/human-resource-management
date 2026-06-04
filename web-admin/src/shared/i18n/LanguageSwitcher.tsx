import { Select } from 'antd';
import { useTranslation } from 'react-i18next';

export function LanguageSwitcher() {
  const { i18n } = useTranslation();
  return (
    <Select
      size="small"
      value={i18n.language}
      onChange={(lang) => i18n.changeLanguage(lang)}
      options={[
        { value: 'vi', label: '🇻🇳 Tiếng Việt' },
        { value: 'en', label: '🇬🇧 English' }
      ]}
      style={{ width: 140 }}
    />
  );
}
