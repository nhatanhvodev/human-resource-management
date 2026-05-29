package com.company.hrms.architecture;

import java.util.List;
import java.util.Optional;

import org.junit.jupiter.api.Test;
import org.springframework.modulith.core.ApplicationModules;

import static org.assertj.core.api.Assertions.assertThat;

class ModuleBoundariesTest {

    private static final List<String> EXPECTED_MODULES = List.of(
            "identity",
            "organization",
            "employee",
            "recruitment",
            "attendance",
            "payroll",
            "reporting",
            "integration",
            "audit"
    );

    @Test
    void verifiesModuleBoundaries() {
        ApplicationModules modules = ApplicationModules.of("com.company.hrms");
        modules.verify();

        assertThat(EXPECTED_MODULES)
                .allSatisfy(module -> assertThat(hasModule(modules, module))
                        .as("module %s should be detected", module)
                        .isTrue());
    }

    private static boolean hasModule(ApplicationModules modules, String moduleName) {
        Object module = modules.getModuleByName(moduleName);

        if (module instanceof Optional<?> optional) {
            return optional.isPresent();
        }

        return module != null;
    }
}
