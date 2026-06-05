import { fireEvent, render, screen, waitFor } from "@testing-library/react";
import { useTranslation } from "react-i18next";
import { describe, expect, it } from "vitest";

import i18n from "./index";
import { LanguageSwitcher } from "./LanguageSwitcher";

function TranslatedLabel() {
  const { t } = useTranslation();
  return <div>{t("nav.dashboard")}</div>;
}

describe("LanguageSwitcher", () => {
  it("shows a supported option for regional browser languages", async () => {
    await i18n.changeLanguage("en-US");

    render(<LanguageSwitcher />);

    expect(await screen.findByText("EN")).toBeInTheDocument();
  });

  it("changes visible translations when English is selected", async () => {
    await i18n.changeLanguage("vi");

    render(
      <>
        <LanguageSwitcher />
        <TranslatedLabel />
      </>
    );

    expect(await screen.findByText("Tổng quan")).toBeInTheDocument();

    fireEvent.mouseDown(screen.getByRole("combobox"));
    fireEvent.click(await screen.findByText("🇬🇧 English"));

    await waitFor(() => {
      expect(screen.getByText("Dashboard")).toBeInTheDocument();
    });
  });
});
