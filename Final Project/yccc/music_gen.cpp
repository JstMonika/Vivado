#include <bits/stdc++.h>
using namespace std;

int main()
{
    int n;
    cin >> n;

    string str;
    cin >> str;

    vector<int> _list;
    
    int idx = 0;
    while (idx < str.size())
    {
        bool up = false, down = false;
        int src;
        if (str[idx] == '+')
        {
            up = true;
            idx++;
        }
        else if (str[idx] == '-')
        {
            down = true;
            idx++;
        }
        

        if (str[idx] == '#')
        {
            idx++;
            

            switch (str[idx])
            {
                case 'A':
                    src = 932;
                    break;
                case 'C':
                    src = 554;
                    break;
                case 'D':
                    src = 622;
                    break;
                case 'F':
                    src = 740;
                    break;
                case 'G':
                    src = 831;
                    break;
            }
        }
        else if (str[idx] == 'N')
        {
            src = 20000;
        }
        else
        {
            switch (str[idx])
            {
                case 'A':
                    src = 880;
                    break;
                case 'B':
                    src = 988;
                    break;
                case 'C':
                    src = 524;
                    break;
                case 'D':
                    src = 588;
                    break;
                case 'E':
                    src = 660;
                    break;
                case 'F':
                    src = 698;
                    break;
                case 'G':
                    src = 784;
                    break;
            }
        }
        
        idx++;

        if (up)
            src *= 2;
        else if (down)
            src /= 2;

        _list.emplace_back(src);
    }

    string len;
    cin >> len;

    vector<int> length;

    for (int i = 0; i < len.size(); i++)
        length.emplace_back(len[i] - '0');
    
    for (int i = 0; i < len.size(); i++)
    {
        for (int k = 0; k < length[i]; k++)
        {
            cout << "\t\t" << "10'd" << n << ": tone = " << "32'd" << _list[i] << ";\n";
            n++;
        }
    }
}