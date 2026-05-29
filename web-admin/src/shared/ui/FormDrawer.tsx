import { Drawer } from "antd";
import type { ReactNode } from "react";

type FormDrawerProps = {
  children: ReactNode;
  open: boolean;
  title: string;
  onClose: () => void;
};

export function FormDrawer({ children, open, title, onClose }: FormDrawerProps) {
  return (
    <Drawer width={420} title={title} open={open} onClose={onClose} destroyOnClose>
      {children}
    </Drawer>
  );
}
