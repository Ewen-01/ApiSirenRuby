class Siren < ApplicationRecord
    def self.search(siren_form)
            # Votre clé d'API
        api_key = '2a91ee8f-0be7-3d3d-96fa-0c74647eef98'

        if siren_form.siren.present?
            # Récupération du numéro de SIREN entré par l'utilisateur
            siren = siren_form.siren

            # Validation du paramètre siren
            if siren.blank?
                error_message = "Veuillez entrer un numéro SIREN."
                return
            elsif !siren.match?(/\A\d{9}\z/)
                error_message = "Le numéro SIREN doit contenir 9 chiffres et ne doit pas contenir de lettre, ni d'espace."
                return
            end

            # Requête à l'API INSEE pour récupérer les données de l'entreprise correspondante
            response = HTTParty.get("https://api.insee.fr/entreprises/sirene/V3/siret?q=siren:#{siren}",
                headers: {
                'Authorization' => "Bearer #{api_key}",
                'Accept' => 'application/json'
                }
            )
            @list = []

            # Si la requête a réussi, on récupère les données et on les stocke dans des variables
            if response.success?
                result = JSON.parse(response.body)
                if result.present?
                    code_siren = result["etablissements"][0]["siren"]
                    code_siret = result["etablissements"][0]["siret"]
                    code_nic = result["etablissements"][0]["nic"]
                    date = result["etablissements"][0]["uniteLegale"]["dateCreationUniteLegale"]
                    categorie = result["etablissements"][0]["uniteLegale"]["categorieEntreprise"]
                    numVoie = result["etablissements"][0]["adresseEtablissement"]["numeroVoieEtablissement"]
                    typeVoie = result["etablissements"][0]["adresseEtablissement"]["typeVoieEtablissement"]
                    libelleVoie = result["etablissements"][0]["adresseEtablissement"]["libelleVoieEtablissement"]
                    code_postal = result["etablissements"][0]["adresseEtablissement"]["codePostalEtablissement"]
                    commune = result["etablissements"][0]["adresseEtablissement"]["libelleCommuneEtablissement"]
                    if result["etablissements"][0]["uniteLegale"]["etatAdministratifUniteLegale"] == "A"
                        etat = "Entreprise en activité"
                    elsif result["etablissements"][0]["uniteLegale"]["etatAdministratifUniteLegale"] == "C"
                        etat = "Entreprise non active"
                    end
                    nom_entreprise = result["etablissements"][0]["uniteLegale"]["denominationUniteLegale"]
                    error_message = nil


                    infoRequest = {
                        "code_siren" => code_siren,
                        "date" => date,
                        "categorie" => categorie,
                        "nom_entreprise" => nom_entreprise,
                        "etat" => etat,
                        "adresse" => numVoie + " " + typeVoie + " " + libelleVoie + ", " + code_postal + " " + commune,
                        "code_siret" => code_siret,
                        "code_nic" => code_nic,
                        "error_message" => error_message
                    }

                    @list.push(infoRequest)
                else
                    error_message = "Impossible de trouver l'entreprise correspondant au numéro de SIREN #{siren}."
                    code_siren = ""
                    date = ""
                    categorie = ""
                    nom_entreprise = ""
                    etat = ""
                    code_siret = ""
                    code_nic = ""
                    numVoie = ""
                    typeVoie = ""
                    libelleVoie = ""
                    code_postal = ""
                    commune = ""

                    infoRequest = {
                        "code_siren" => code_siren,
                        "date" => date,
                        "categorie" => categorie,
                        "nom_entreprise" => nom_entreprise,
                        "etat" => etat,
                        "adresse" => numVoie + " " + typeVoie + " " + libelleVoie + ", " + code_postal + " " + commune,
                        "code_siret" => code_siret,
                        "code_nic" => code_nic,
                        "error_message" => error_message
                    }

                    @list.push(infoRequest)
                end
            else
                error_message = "Impossible de trouver l'entreprise correspondant au numéro de SIREN #{siren}."
                code_siren = ""
                date = ""
                categorie = ""
                nom_entreprise = ""
                etat = ""
                code_siret = ""
                code_nic = ""
                numVoie = ""
                typeVoie = ""
                libelleVoie = ""
                code_postal = ""
                commune = ""

                infoRequest = {
                    "code_siren" => code_siren,
                    "date" => date,
                    "categorie" => categorie,
                    "nom_entreprise" => nom_entreprise,
                    "etat" => etat,
                    "adresse" => numVoie + " " + typeVoie + " " + libelleVoie + ", " + code_postal + " " + commune,
                    "code_siret" => code_siret,
                    "code_nic" => code_nic,
                    "error_message" => error_message
                }

                @list.push(infoRequest)
            end
            return @list

        elsif siren_form.name.present?
            # Récupération du nom d'entreprise entré par l'utilisateur
            name = siren_form.name

            if name.blank?
                error_message = "Veuillez entrer un nom d'entreprise."
                return
            end

            # Requête à l'API INSEE pour récupérer les données de l'entreprise correspondante
            response = HTTParty.get("https://api.insee.fr/entreprises/sirene/V3/siret?q=denominationUniteLegale:\"#{name}*\"", 
                headers: {
                'Authorization' => "Bearer #{api_key}",
                'Accept' => 'application/json'
                }
            )

            @list = []
            # Si la requête a réussi, on récupère les données et on les stocke dans des variables
            if response.success?
                result = JSON.parse(response.body)
                if result.present?
                    
                    result["etablissements"].each do |etablissement|
                        code_siren = etablissement["siren"]
                        code_siret = etablissement["siret"]
                        code_nic = etablissement["nic"]
                        date = etablissement["uniteLegale"]["dateCreationUniteLegale"]
                        categorie = etablissement["uniteLegale"]["categorieEntreprise"]
                        numVoie = etablissement["adresseEtablissement"]["numeroVoieEtablissement"]
                        typeVoie = etablissement["adresseEtablissement"]["typeVoieEtablissement"]
                        libelleVoie = etablissement["adresseEtablissement"]["libelleVoieEtablissement"]
                        code_postal = etablissement["adresseEtablissement"]["codePostalEtablissement"]
                        commune = etablissement["adresseEtablissement"]["libelleCommuneEtablissement"]

                        if etablissement["uniteLegale"]["etatAdministratifUniteLegale"] == "A"
                            etat = "Entreprise en activité"
                        elsif etablissement["uniteLegale"]["etatAdministratifUniteLegale"] == "C"
                            etat = "Entreprise non active"
                        end

                        nom_entreprise = etablissement["uniteLegale"]["denominationUniteLegale"]
                        error_message = nil

                        infoRequest = {
                            "code_siren" => code_siren,
                            "date" => date,
                            "categorie" => categorie,
                            "nom_entreprise" => nom_entreprise,
                            "etat" => etat,
                            "adresse" => "#{numVoie} #{typeVoie} #{libelleVoie}, #{code_postal} #{commune}",
                            "code_siret" => code_siret,
                            "code_nic" => code_nic,
                            "error_message" => error_message
                        }

                        @list << infoRequest
                    end
                else
                    # Si la requête a échoué, on affiche un message d'erreur
                    error_message = "Impossible de trouver l'entreprise #{name}"
                    code_siren = ""
                    date = ""
                    categorie = ""
                    nom_entreprise = ""
                    etat = ""
                    code_siret = ""
                    code_nic = ""
                    numVoie = ""
                    typeVoie = ""
                    libelleVoie = ""
                    code_postal = ""
                    commune = ""

                    infoRequest = {
                        "code_siren" => code_siren,
                        "date" => date,
                        "categorie" => categorie,
                        "nom_entreprise" => nom_entreprise,
                        "etat" => etat,
                        "adresse" => numVoie + " " + typeVoie + " " + libelleVoie + ", " + code_postal + " " + commune,
                        "code_siret" => code_siret,
                        "code_nic" => code_nic,
                        "error_message" => error_message
                    }

                    @list << infoRequest
                end
            else
                # Si la requête a échoué, on affiche un message d'erreur
                error_message = "Impossible de trouver l'entreprise #{name}"
                code_siren = ""
                date = ""
                categorie = ""
                nom_entreprise = ""
                etat = ""
                code_siret = ""
                code_nic = ""
                numVoie = ""
                typeVoie = ""
                libelleVoie = ""
                code_postal = ""
                commune = ""


                infoRequest = {
                    "code_siren" => code_siren,
                    "date" => date,
                    "categorie" => categorie,
                    "nom_entreprise" => nom_entreprise,
                    "etat" => etat,
                    "adresse" => numVoie + " " + typeVoie + " " + libelleVoie + ", " + code_postal + " " + commune,
                    "code_siret" => code_siret,
                    "code_nic" => code_nic,
                    "error_message" => error_message
                }

                @list.push(infoRequest)
            end
            return @list
        end
    end
end
