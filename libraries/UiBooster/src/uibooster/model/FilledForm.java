package uibooster.model;

import javax.swing.*;
import java.util.List;
import java.util.Objects;

public class FilledForm {

    private final JDialog window;
    private final List<FormElement> elements;

    public FilledForm(JDialog dialog, List<FormElement> elements) {
        window = dialog;
        this.elements = elements;
    }

    public FormElement getById(String id) {
        return elements.stream()
                .filter(element -> Objects.nonNull(element.id))
                .filter(element -> element.id.equals(id))
                .findFirst().get();
    }

    public FormElement getByIndex(int index) {
        return elements.get(index);
    }

    public FormElement getByLabel(String label) {
        return elements.stream()
                .filter(element -> Objects.nonNull(element.label))
                .filter(element -> element.label.equals(label))
                .findFirst().get();
    }

    public List<FormElement> getElements() {
        return elements;
    }

    /**
     * Hides the form window, but keeps the form data.
     *
     * @return the current FilledForm object for method chaining
     */
    public FilledForm hide() {
        window.setVisible(false);
        return this;
    }

    /**
     * Shows the window again, if it's hidden
     *
     * @return
     */
    public FilledForm show() {
        if (!window.isVisible())
            window.setVisible(true);
        return this;
    }

    /**
     * Closes the form window and removes the form data.
     */
    public void close() {
        window.dispose();
    }

    public JDialog getWindow() {
        return window;
    }
}
