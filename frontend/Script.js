
const boardElement = document.getElementById("board");
const messageElement = document.getElementById("message");

let selectedPosition = null;

// Representação visual temporária do tabuleiro
let board = [];

function createInitialBoard() {
    board = Array.from({ length: 8 }, () =>
        Array(8).fill(null)
    );

    for (let row = 0; row < 3; row++) {
        for (let col = 0; col < 8; col++) {
            if ((row + col) % 2 === 1) {
                board[row][col] = "black";
            }
        }
    }

    for (let row = 5; row < 8; row++) {
        for (let col = 0; col < 8; col++) {
            if ((row + col) % 2 === 1) {
                board[row][col] = "white";
            }
        }
    }

    selectedPosition = null;
    renderBoard();
}

function renderBoard() {
    boardElement.innerHTML = "";

    for (let row = 0; row < 8; row++) {
        for (let col = 0; col < 8; col++) {
            const square = document.createElement("div");

            square.classList.add("square");
            square.classList.add(
                (row + col) % 2 === 0 ? "light" : "dark"
            );

            if (
                selectedPosition &&
                selectedPosition.row === row &&
                selectedPosition.col === col
            ) {
                square.classList.add("selected");
            }

            const piece = board[row][col];

            if (piece) {
                const pieceElement = document.createElement("div");

                pieceElement.classList.add("piece");
                pieceElement.classList.add(
                    piece === "white" ? "white-piece" : "black-piece"
                );

                square.appendChild(pieceElement);
            }

            square.addEventListener("click", () => {
                handleSquareClick(row, col);
            });

            boardElement.appendChild(square);
        }
    }
}

function handleSquareClick(row, col) {
    const piece = board[row][col];

    if (!selectedPosition) {
        if (!piece) {
            messageElement.textContent =
                "Seleciona uma casa com uma peça.";
            return;
        }

        selectedPosition = { row, col };
        messageElement.textContent =
            "Agora seleciona a casa de destino.";

    } else {
        const source = selectedPosition;
        const destination = { row, col };

        // Por enquanto, apenas mostramos a jogada pretendida.
        messageElement.textContent =
            `Jogada: (${source.row}, ${source.col}) → ` +
            `(${destination.row}, ${destination.col})`;

        selectedPosition = null;
    }

    renderBoard();
}

document.getElementById("reset-button")
    .addEventListener("click", createInitialBoard);

createInitialBoard();
