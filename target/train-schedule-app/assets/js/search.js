/**
 * Real-time Table Filter
 * Filters table rows based on user input.
 * 
 * Usage:
 * setupSearch('searchInput', 'dataTable');
 */

function setupSearch(inputId, tableId) {
    const input = document.getElementById(inputId);
    const table = document.getElementById(tableId);

    if (!input || !table) return;

    input.addEventListener('keyup', function () {
        const filter = input.value.toLowerCase();
        const tbody = table.getElementsByTagName('tbody')[0];
        const rows = tbody.getElementsByTagName('tr');
        let hasVisibleRows = false;

        for (let i = 0; i < rows.length; i++) {
            const row = rows[i];

            // Skip "No results" row if it exists (usually has a specific class or we allow it to be filtered out and re-added)
            if (row.classList.contains('no-results')) {
                row.remove();
                i--; // Adjust index since we removed a row
                continue;
            }

            const cells = row.getElementsByTagName('td');
            let match = false;

            for (let j = 0; j < cells.length; j++) {
                const cell = cells[j];
                if (cell) {
                    const textValue = cell.textContent || cell.innerText;
                    if (textValue.toLowerCase().indexOf(filter) > -1) {
                        match = true;
                        break;
                    }
                }
            }

            if (match) {
                row.style.display = "";
                hasVisibleRows = true;
            } else {
                row.style.display = "none";
            }
        }

        // Handle "No results" message
        let noResultRow = document.getElementById('noResultsRow');
        if (!hasVisibleRows) {
            if (!noResultRow) {
                noResultRow = document.createElement('tr');
                noResultRow.id = 'noResultsRow';
                noResultRow.classList.add('no-results');
                const colSpan = table.getElementsByTagName('th').length;
                noResultRow.innerHTML = `<td colspan="${colSpan}" style="text-align: center; padding: 2rem; color: #6b7280;">No results found matching "${input.value}"</td>`;
                tbody.appendChild(noResultRow);
            } else {
                noResultRow.innerHTML = `<td colspan="${table.getElementsByTagName('th').length}" style="text-align: center; padding: 2rem; color: #6b7280;">No results found matching "${input.value}"</td>`;
                noResultRow.style.display = "";
            }
        } else {
            if (noResultRow) {
                noResultRow.style.display = "none";
            }
        }
    });
}
