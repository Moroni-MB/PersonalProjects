#include <iostream>
#include <vector>
#include <fstream>
using namespace std;




class Transaction {
public:
    double amount;
    string type;      // "income" or "expense"
    string category;

    Transaction(double amt, string t, string cat) {
        amount = amt;
        type = t;
        category = cat;
    }
};

class BudgetManager {
private:
    vector<Transaction> transactions;

public:
    void addTransaction(double amount, string type, string category) {
        transactions.push_back(Transaction(amount, type, category));
    }

    void viewTransactions() {
        for (const auto& t : transactions) {
            cout << t.type << " | "
                 << t.category << " | $"
                 << t.amount << endl;
        }
    }

    double calculateBalance() {
        double balance = 0;

        for (const auto& t : transactions) {
            if (t.type == "income")
                balance += t.amount;
            else
                balance -= t.amount;
        }

        return balance;
    }

    void saveToFile() {
        ofstream file("budget.txt");

        for (const auto& t : transactions) {
            file << t.type << " "
                 << t.category << " "
                 << t.amount << endl;
        }

        file.close();
    }

    void loadFromFile() {
        ifstream file("budget.txt");

        string type, category;
        double amount;

        while (file >> type >> category >> amount) {
            transactions.push_back(Transaction(amount, type, category));
        }

        file.close();
    }
};


int main() {
    BudgetManager manager;
    manager.loadFromFile();

    int choice;

    do {
        cout << "\n--- Budget Manager ---\n";
        cout << "1. Add Income\n";
        cout << "2. Add Expense\n";
        cout << "3. View Transactions\n";
        cout << "4. View Balance\n";
        cout << "5. Save & Exit\n";
        cout << "Enter choice: ";
        cin >> choice;

        if (choice == 1 || choice == 2) {
            double amount;
            string category;

            cout << "Enter amount: ";
            cin >> amount;

            cout << "Enter category: ";
            cin >> category;

            if (choice == 1)
                manager.addTransaction(amount, "income", category);
            else
                manager.addTransaction(amount, "expense", category);
        }
        else if (choice == 3) {
            manager.viewTransactions();
        }
        else if (choice == 4) {
            cout << "Balance: $" << manager.calculateBalance() << endl;
        }

    } while (choice != 5);

    manager.saveToFile();

    return 0;
}
