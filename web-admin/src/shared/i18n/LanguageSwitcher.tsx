import { Select } from "antd";
import { useTranslation } from "react-i18next";

import "./index";

const supportedLanguages = ["vi", "en"] as const;
type SupportedLanguage = (typeof supportedLanguages)[number];

function normalizeLanguage(language: string | undefined): SupportedLanguage {
  const baseLanguage = language?.split("-")[0];
  return supportedLanguages.includes(baseLanguage as SupportedLanguage) ? (baseLanguage as SupportedLanguage) : "vi";
}

export function LanguageSwitcher() {
  const { i18n } = useTranslation();
  const currentLanguage = normalizeLanguage(i18n.resolvedLanguage ?? i18n.language);

  return (
    <Select
      className="language-switcher"
      size="small"
      value={currentLanguage}
      onChange={(lang) => i18n.changeLanguage(lang)}
      labelRender={({ value }) => String(value).toUpperCase()}
      options={[
        { value: "vi", label: "🇻🇳 Tiếng Việt" },
        { value: "en", label: "🇬🇧 English" }
      ]}
      style={{ width: 72 }}
    />
  );
}
