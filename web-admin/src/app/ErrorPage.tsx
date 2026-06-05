import { Alert, Button } from "antd";
import { useTranslation } from "react-i18next";
import { isRouteErrorResponse, useNavigate, useRouteError } from "react-router-dom";

export default function ErrorPage() {
  const { t } = useTranslation();
  const error = useRouteError();
  const navigate = useNavigate();
  const message = isRouteErrorResponse(error)
    ? `${error.status} ${error.statusText}`
    : error instanceof Error
      ? error.message
      : t("errorPage.unknown");

  return (
    <div className="error-page">
      <Alert
        type="error"
        showIcon
        message={t("errorPage.title")}
        description={message}
        action={
          <Button size="small" onClick={() => navigate("/dashboard")}>
            {t("errorPage.backToDashboard")}
          </Button>
        }
      />
    </div>
  );
}
